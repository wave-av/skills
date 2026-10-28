#!/usr/bin/env bash
# crew-skill-index — every skills/<id>/SKILL.md has name and description
# frontmatter, the README skill-index block lists that id (when-to-use matches
# the description), standing rules are marked REQUIRED, and those files hold
# no secret-shaped strings.
#
# Fail closed. Zero skills, a missing index block, or an unlisted skill is an
# error. This is not a no-op when the tree has nothing to check.
set -euo pipefail
cd "$(dirname "$0")/../.."

if ! python3 -c 'import yaml' 2>/dev/null; then
  echo "PyYAML not in image; installing pinned pyyaml into a temp dir"
  PYDIR="$(mktemp -d)"
  trap 'rm -rf "$PYDIR"' EXIT
  python3 -m pip install --quiet --target "$PYDIR" 'pyyaml==6.2.1'
  export PYTHONPATH="$PYDIR${PYTHONPATH:+:$PYTHONPATH}"
fi

python3 - <<'PY'
import os, re, sys
import yaml

REQUIRED = {
    "build-our-own-tooling",
    "cross-account-bot-bus",
    "decision-flag",
    "durable-work-never-in-temp",
    "usage-efficient-crew",
}
KEBAB = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
SKIP_DIRS = {".git", "node_modules", "dist", "build", ".next", "target", "vendor"}
errs = []

def collapse(text):
    return " ".join(str(text).split())

skill_ids = []
descriptions = {}
skills_root = "skills"
if not os.path.isdir(skills_root):
    errs.append("skills/ directory is missing")
else:
    for name in sorted(os.listdir(skills_root)):
        path = os.path.join(skills_root, name)
        if not os.path.isdir(path) or name.startswith("."):
            continue
        if not KEBAB.fullmatch(name):
            errs.append(f"{path}: directory name is not kebab-case")
        skill = os.path.join(path, "SKILL.md")
        if not os.path.isfile(skill):
            errs.append(f"{path}: missing SKILL.md")
            continue
        skill_ids.append(name)
        text = open(skill, encoding="utf-8", errors="replace").read()
        m = re.match(r"^---\s*\n(.*?)\n---", text, re.S)
        if not m:
            errs.append(f"{skill}: no frontmatter block")
            continue
        fm = m.group(1)
        seen, dup = set(), set()
        for line in fm.split("\n"):
            k = re.match(r"^([A-Za-z_][\w-]*):", line)
            if k:
                (dup if k.group(1) in seen else seen).add(k.group(1))
        if dup:
            errs.append(f"{skill}: duplicate frontmatter keys: {', '.join(sorted(dup))}")
        try:
            data = yaml.safe_load(fm) or {}
        except yaml.YAMLError as e:
            errs.append(f"{skill}: invalid YAML frontmatter: {e}")
            continue
        if not isinstance(data, dict):
            errs.append(f"{skill}: frontmatter is not a mapping")
            continue
        if data.get("name") != name:
            errs.append(f"{skill}: name {data.get('name')!r} != directory {name!r}")
        desc = data.get("description")
        if not isinstance(desc, str) or not desc.strip():
            errs.append(f"{skill}: missing/empty description")
        else:
            descriptions[name] = collapse(desc)

if not skill_ids and not errs:
    errs.append("no skill directories under skills/ — refusing to pass an empty tree")

for dirpath, dirnames, filenames in os.walk("."):
    dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS and not d.startswith(".")]
    if "SKILL.md" not in filenames:
        continue
    rel = os.path.relpath(os.path.join(dirpath, "SKILL.md"), ".")
    parts = rel.split(os.sep)
    if len(parts) != 3 or parts[0] != "skills" or parts[2] != "SKILL.md":
        errs.append(f"{rel}: skill files must live at skills/<id>/SKILL.md")

readme_path = "README.md"
if not os.path.isfile(readme_path):
    errs.append("README.md is missing")
    block = ""
else:
    readme = open(readme_path, encoding="utf-8", errors="replace").read()
    begin, end = "<!-- skill-index: begin -->", "<!-- skill-index: end -->"
    if begin not in readme or end not in readme or readme.find(begin) > readme.find(end):
        errs.append("README.md is missing a single skill-index block")
        block = ""
    else:
        block = readme.split(begin, 1)[1].split(end, 1)[0]
        if begin in block or end in block:
            errs.append("README.md skill-index markers are not a single block")

listed = {}
for raw in block.splitlines():
    line = raw.strip()
    if not line.startswith("|"):
        continue
    cells = [c.strip() for c in line.strip().strip("|").split("|")]
    if not cells:
        continue
    if cells[0].lower() == "skill":
        continue
    if all(re.fullmatch(r":?-{3,}:?", c) for c in cells):
        continue
    mid = re.fullmatch(r"`([a-z0-9]+(?:-[a-z0-9]+)*)`", cells[0])
    if not mid:
        errs.append(f"skill index row has a bad id cell: {cells[0]!r}")
        continue
    sid = mid.group(1)
    if sid in listed:
        errs.append(f"skill index lists {sid} more than once")
    if len(cells) < 3:
        errs.append(f"skill index row for {sid} needs skill, standing rule, and when-to-use columns")
        continue
    rule, when = cells[1], cells[2]
    if rule not in ("", "REQUIRED"):
        errs.append(f"skill index standing rule for {sid} must be REQUIRED or empty, got {rule!r}")
    if not when.strip():
        errs.append(f"skill index when-to-use for {sid} is empty")
    elif sid in descriptions and when != descriptions[sid]:
        errs.append(f"skill index when-to-use for {sid} does not match its description")
    listed[sid] = rule

for sid in skill_ids:
    if sid not in listed:
        errs.append(f"skill index does not list {sid}")
for sid in listed:
    if sid not in skill_ids:
        errs.append(f"skill index lists {sid} but skills/{sid}/SKILL.md is missing")
for sid in sorted(REQUIRED):
    if listed.get(sid) != "REQUIRED":
        errs.append(f"{sid} is a standing rule and must be marked REQUIRED")
for sid, rule in sorted(listed.items()):
    if rule == "REQUIRED" and sid not in REQUIRED:
        errs.append(f"{sid} is marked REQUIRED but is not a standing rule")

for e in errs:
    print(f"error: {e}")
print(f"crew-skill-index: {len(skill_ids)} skills, {len(listed)} index rows, {len(errs)} errors")
sys.exit(1 if errs else 0)
PY

# Secret-shaped strings in the skills and the index. The pattern text lives in
# this script, which is outside the scan roots, so it cannot match itself.
# Lines tagged "allowlist secret" are skipped, same as the foundation scan.
HITS=$(grep -rIEn --exclude-dir=.git \
  '(sk-[A-Za-z0-9]{20}|sk-ant-(api|admin)[0-9]{2}-[A-Za-z0-9_-]{20,}|sk_(live|test)_[A-Za-z0-9]{20}|npm_[A-Za-z0-9]{30}|sbp_[a-f0-9]{40}|github_pat_[A-Za-z0-9_]{40}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30}|AIzaSy[A-Za-z0-9_-]{20}|xai-[A-Za-z0-9]{40}|xoxb-[A-Za-z0-9-]+|-----BEGIN [A-Z ]*PRIVATE KEY|100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\.[0-9]{1,3}\.[0-9]{1,3})' \
  skills README.md | grep -v 'allowlist secret' || true)
if [ -n "$HITS" ]; then
  echo "secret-like pattern found in skills or the skill index — do not commit credentials"
  echo "$HITS"
  exit 1
fi
echo "crew-skill-index: secret-scan clean"
