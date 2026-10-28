---
name: landing-page-design
description: >-
  Use when building, editing, or reviewing a landing page, marketing site, page
  section, or product mockup, or when animating a static design into showcase
  motion (MP4/GIF). Covers intake, structure, conversion copy, SEO, a
  token-driven visual system, states, motion, and verification.
---
# Landing page and motion design

Adapted from elayadesign/ai-design-skills (`landing-page-design`, `design-to-motion`, MIT, (c) 2026 Elaya), which credits Leonxlnx/taste-skill (MIT, (c) 2026 Leonxlnx). See Credits. This version is changed: the brand's tokens win over the defaults, there's a verification loop, and invented content is allowed only in mockups.

A landing page wins a single intent: **one offer → one audience → one primary action.**

Order of authority: **the user's explicit ask > the brand's tokens/design system > this file's defaults > framework defaults.**

Work through Part A (what the page says) before Part B (how it looks). Part C covers motion. Part D covers verification.

---

## 0. Load the brand first

Before you design anything, find the brand's design source of truth: tokens file (W3C design tokens JSON, Tailwind config, CSS custom properties), brand docs (e.g. `docs/brand/*`), existing components. Use its fonts, colors (OKLCH where the brand uses it), radii, spacing, and icon set. Use the **Defaults** in section B9 only where the brand doesn't specify a value, and say which defaults you used. Never fork brand values ad hoc.

---

# PART A — Strategy and structure

## A1. Intake (one batch, only what's missing)
- **Purpose:** the ONE primary action (trial, demo, buy, waitlist, download); the exact offer; what counts as a conversion.
- **Audience:** ICP; the problem; top three objections; traffic source (ads, search, social, email); what visitors already know.
- **Proof/assets:** logos, testimonials, numbers, case studies, screenshots, demo video, guarantees/refund/cancel terms.
- **Constraints:** voice, design direction, mobile priority, legal/region (cookie consent).
If unanswered, make a reasonable assumption, state it in one line, and continue. Don't stall.

## A2. Page structure
Above the fold: (1) headline = outcome + audience, (2) subheadline = how, specific, (3) primary CTA = verb + what they get, (4) one proof signal, (5) hero visual (real product screenshot/video preferred).
Mid page: (6) problem→solution, (7) 3–5 outcome benefits, (8) how it works in 3 steps, (9) social proof next to the claim it supports, plus one **tagline moment** (B7).
Bottom: (10) FAQ 6–12 Qs, (11) risk reversal, (12) final CTA identical to the top.

## A3. Layout choice (pick one, say why)
A classic hero + sections (understandable from a screenshot) · B long-form story (needs education) · C minimal conversion (high-intent/email/waitlist) · D comparison ("X vs Y", alternatives intent; pairs with SEO).

## A4. Conversion rules
- Mirror the ad/source headline and promise in the hero.
- One primary CTA; no competing CTAs above the fold.
- Benefit first; be specific ("4 hours → 15 minutes", not "streamline").
- At least one risk reducer (free plan/trial, no card, cancel anytime, guarantee).
- Objections are a section; move FAQ up for high-friction offers.

## A5. Copy
Headline formulas: "{Outcome} without {pain}", "The {category} for {audience}", "Ship {result} in {time}". CTA is verb + object, never "Learn more"/"Submit". Bullets: **bold benefit** — proof/detail. Sentence case. Banned filler: revolutionize, supercharge, cutting edge, effortless, transform your workflow, next level, harness the power, world class. Prefer rewriting over mid-sentence hyphens/dashes. No orphaned last-line words (`text-wrap: balance` for headings, `pretty` for body).

## A6. Build order
Return outline → hero copy → benefits → how it works → FAQ → SEO/AEO call → layout choice **before code**. Then build section by section (hero, benefits, how, proof, FAQ, final CTA). Never regenerate the whole page per iteration; keep diffs reviewable.

## A7. SEO / AEO
`noindex` ad-only or time-bound pages. Index evergreen ones: title, meta description, internal links, FAQ in plain Q&A (FAQ schema where appropriate), og/social tags.

## A8. Content honesty
- **Mockups/prototypes:** write realistic copy, names, odd-looking numbers and industry-plausible brands. No lorem ipsum.
- **Public pages:** only real testimonials, logos, metrics, and customers, with permission. Anything invented stays visibly marked `TODO(real proof)` and blocks ship. Never invent a customer, a quote, or a number on a live page.
- System messages are calm and specific ("Invoice sent to Dana"); errors say what failed and what to do next. No exclamation marks.

---

# PART B — Visual system

Every value resolves to a token (brand first, else B9 defaults). No arbitrary values.

## B1. Typography
One typeface per site (a mono allowed for code/data). No italics in UI chrome, no 900/black weights. Snap sizes to the type scale (Tailwind default steps with their paired line heights; snap down when between). Buttons: main `text-base` semibold, header `text-sm` semibold.

## B2. Spacing and radius
Spacing only from the scale (default: 0, 2, 4, 8, 12, 16, 24, 32, 40, 48, 64, 80, 96 px). Main buttons are 8px tall padding and 12px wide.
Nested radius: when the gap is < 32px, `inner = outer − gap`, applied only if the result is > 2.

## B3. Borders, backgrounds, color
Borders go all the way around or not at all. Backgrounds are flat (no background gradients). Gradients are allowed only on hero heading text when the brand permits it. Meet WCAG 2.2 AA contrast on every text/background pair.

## B4. Hero
Heading and subheading capped at about 680px. Break lines where the thought breaks.

## B5. Icons
Use one icon family, the brand's or else Phosphor/Solar/Iconamoon. Don't mix families. Avoid Material Icons unless the brand uses it.

## B6. States and ship list
Every interactive element: hover, active (`scale(0.98)`/`translateY(1px)`), visible focus ring, skeleton loading shaped like real content, composed empty state, inline specific errors (never `alert()`). No `#` dead links; the current nav item is indicated.
Ship: privacy/terms in footer, branded 404, client-side validation, skip link, cookie consent where required, favicon, title/meta/og tags, alt text, semantic landmarks, a way back from every page.

## B7. Tagline moment (recommended, not mandatory)
One large-type section (≥2 lines, `text-4xl`–`text-6xl`, capped width) that states the core benefit. Optional reveal: words go from about 30% to full opacity in reading order as they cross a trigger line. Use CSS scroll-driven animations (`animation-timeline: view()`) where supported, else IntersectionObserver. Never use an unthrottled scroll listener.

## B8. Product UI motion (on the page itself)
- Base curve `cubic-bezier(0.22,1,0.36,1)`: 500ms for layout/position, 200–300ms for hover color/opacity. Never browser `ease`/`linear` for entrances.
- Animate `transform`/`opacity` (plus `filter`/`clip-path` sparingly); never top/left/width/height.
- Scroll reveals rise 32px and fade over 600–800ms, once per section.
- Nav: compact floating translucent bar with blur. The toggle icon morphs. Mobile menu is a full-height blurred panel. Links stagger 60ms, total ≤400ms.
- `prefers-reduced-motion`: replace movement with an opacity change (or the still frame).

## B9. Defaults (only when the brand is silent; edit here to re-skin)
| Key | Default |
|---|---|
| Fonts | Geist or Manrope (+ Geist Mono). Avoid generic system stacks for display type |
| Dark surfaces | #000000 #181818 #1F1F1F #272727 #313131 |
| Hero text gradient | dark #FFFFFF→#9B9B9B, light #000000→#666666 |
| Spacing | scale in B2 |
| Radius | Tailwind steps |
| Motion curve | cubic-bezier(0.22,1,0.36,1) |

---

# PART C — Design to motion (feature/bento cards and showcase loops)

Decide the context first:
| | Showcase (a design only, "animate this") | Website (inside a site codebase) |
|---|---|---|
| Animate | Whole frame | Only sections with a visual part. Text-only sections get none |
| Start | Page load, from empty | Scroll into view, once |
| After intro | Stories, then dissolve and repeat | Stories run while in view, no dissolve |
| Text | Exported layers (pixel exact) | Live HTML text (SEO, a11y) |
| Deliver | Page + MP4/GIFs | Code in the site. Exports only if asked |

**C1 Fidelity.** The source of truth is the Figma REST API or a flat image. Read the Figma token only from the secrets manager or env. Never print it, put it in argv/URLs, commit it, or paste it. Rebuild so the still matches the reference, and say plainly what can't be separated from a flat image. Keep the background exactly as designed: it never moves, blurs, or fades.

**C2 Start empty, then load.** Rise + blur→sharp, staggered in reading order (containers 80–90ms apart, items 30–80ms). Kinds: card (24px, scale .985, blur 6px), up/down/left (8–10px, blur 4px), pop (scale .82–.88, never from 0), photo (skeleton then blur→sharp), wipe for bars (left→right clip-path), line/grow, donut sweep. Intro is about 2–2.5s. Never add shapes that aren't in the design.

**C3 Stories.** After load, every visual acts out what it does, in one sentence written first: a stack receives a new item, a chart gets scrubbed, a calendar finds a slot, pulses travel a pipeline, a prompt retypes, counters count, a logo marquee loops seamlessly. Each starts and ends on the exact design. Offset cards so they don't move in unison, with a visible beat every 1–2s. Only counters and typing change text.

**C4 Easing.** `--e` cubic-bezier(0.16,1,0.3,1) for transforms (about 1.05s), `--e2` cubic-bezier(0.33,1,0.68,1) for opacity/blur (0.7–0.8s), `--io` cubic-bezier(0.65,0,0.35,1) for wipes. Showcase is deliberately slower than product UI. Keep blur ≤14px. No zoom/pan unless asked.

**C5 Export (showcase).** Use deterministic capture: Playwright fake clock, whole-ms steps averaging 1000/60, and a screenshot per frame. Never real-time screen recording. Outputs: `<name>-x.mp4` (H.264 yuv420p 60fps CRF 15, ≤1920×1200, even dims, +faststart), `<name>-loop.gif` (960w, 15–20fps, bayer dither), `<name>-800x500.gif`. Check before encoding: overflow (nothing escapes its container), seam (first frame = one cycle later), rest (the last story frame = still).

---

# PART D — Verify before you call it done

1. Screenshot desktop (1440) and mobile (390) for every section. Compare against the outline and this checklist.
2. Run a token lint: no arbitrary font sizes, spacing, radii, or colors outside tokens.
3. Run an a11y scan (axe or equivalent): contrast, focus order, landmarks, alt text.
4. Check performance: LCP image prioritized, CLS ≈ 0, motion only on compositor properties. Respect reduced motion.
5. Walk the primary CTA path end to end and record proof (video/filmstrip) when the repo requires walk artifacts.
6. Content honesty: no `TODO(real proof)` left on a public page.
Ship only to a per-PR preview first.

---

# Quick checklist
**Strategy:** one offer/audience/action · no competing CTAs above fold · specific numbers · risk reversal · proof beside claims · layout chosen with reason.
**Visual:** brand tokens loaded · one typeface, no italics/black · sizes on the scale · spacing on the scale · nested radii · full borders, flat backgrounds · hero ≤680px with meaningful breaks · one icon family · motion curve + IntersectionObserver/scroll-timeline · AA contrast.
**Content/ship:** real copy · real proof on public pages · all six states · no dead links · 404, legal, validation, favicon, meta, alt, skip link.
**Motion (if any):** context decided · starts empty · stories start/end on design · offset · reduced motion · exports pass seam/overflow/rest checks.

---

# Credits
- elayadesign/ai-design-skills by Elaya (`landing-page-design`, `design-to-motion`), MIT License, Copyright (c) 2026 Elaya. Source commit a2735a3eaf092eaaffb6dc17df25de33ef3bd048.
- That work credits Leonxlnx/taste-skill (MIT, Copyright (c) 2026 Leonxlnx), emilkowalski/skills, Owl-Listener/designer-skills, and dylantarre/animation-principles (all MIT per upstream).

MIT License text (applies to the adapted portions):

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
