# Design System Orchestrator (READ AND FOLLOW — NOT OPTIONAL)

The #1 failure of this skill so far: the agent generated a generic, "AI-made"
frontend and IGNORED the design skills. That is forbidden. This file is the
hard contract for the Design phase. You may NOT generate a single line of
frontend until you have completed every step here and passed the self-audit at
the bottom.

All design skills are embedded under `references/design/`:
- `references/design/taste-suite/` — the taste-skill family (core + style skills).
- `references/design/ui-ux-pro-max/` — pattern/palette/typography database + CLI.

## STEP 0 — Load the skills (mandatory reads)
Before designing anything you MUST actually open and read, in full:
1. `references/design/taste-suite/taste-skill/SKILL.md` (core anti-slop rules).
2. The ONE style skill you pick in Step 2 (read its entire SKILL.md).
3. `references/design/taste-suite/output-skill/SKILL.md` (never truncate code).
Do not work from memory or this summary alone — open the files. If you skip the
reads, you will produce slop again.

## STEP 1 — Run the questionnaire
Run `references/frontend-questions.md` end to end, in the user's language. Do not
shortcut it. The user explicitly complained you ask too few design questions —
ask ALL of them, in small batches, with follow-ups, until every surface is
specified. Never assume a default silently.

## STEP 2 — Pick ONE aesthetic style skill (with the user)
Demonlists are dark, competitive, data-heavy apps, but the look is the user's
choice. Show the options below, recommend one, and let the user decide. Then
commit to that ONE skill for the whole project — do not mix styles.

| Style skill | File (under taste-suite/) | Use when the user wants... |
|---|---|---|
| **industrial-brutalist-ui** | `brutalist-skill/SKILL.md` | raw, tactical/CRT terminal or Swiss-print look, huge type, mono data, hazard-red accent — a natural fit for a hardcore GD list |
| **high-end-visual-design** | `soft-skill/SKILL.md` | premium "$150k agency" feel: deep OLED dark, double-bezel cards, spring motion, Awwwards polish |
| **minimalist-ui** | `minimalist-skill/SKILL.md` | clean editorial, warm monochrome, flat bento, muted pastels (lighter/calmer list) |
| **design-taste-frontend (core only)** | `taste-skill/SKILL.md` | a custom direction — still apply the core anti-slop rules on top of whatever you build |

Whatever they pick, the **core** `taste-skill/SKILL.md` rules ALWAYS apply on
top (anti-AI-tells, no default purple, no em-dashes, the 3 dials).

## STEP 3 — Support skills (use as needed)
- `brandkit/SKILL.md` — design the list's logo, wordmark, color system, and brand
  world (e.g. the "SHITTY LEVELS LIST" mark). Use before locking theme tokens.
- `ui-ux-pro-max/` — pull concrete patterns, palettes, font pairings:
  `python3 references/design/ui-ux-pro-max/scripts/search.py "<query>" --design-system`
  (use it for leaderboard tables, cards, tabs, badges, level pages).
- `image-to-code-skill/SKILL.md` + `imagegen-frontend-web/SKILL.md` — when image
  generation is available, generate per-section reference images FIRST, analyze
  them deeply, then build to match (kills the "looks AI" drift).
- `imagegen-frontend-mobile/SKILL.md` — same, for the mobile layout.
- `stitch-skill/SKILL.md` — use its format to write the project `DESIGN.md`.
- `redesign-skill/SKILL.md` — when improving an EXISTING list/frontend: run its
  audit and fix the generic patterns instead of rewriting from scratch.
- `output-skill/SKILL.md` — ALWAYS: never truncate code, no `// ...`, no
  "rest follows", deliver every file complete.

## STEP 4 — Lock the design + write DESIGN.md
- Produce a one-line **Design Read** and lock the 3 dials
  (DESIGN_VARIANCE / MOTION_INTENSITY / VISUAL_DENSITY) per the chosen style.
- Pull concrete palette, typography, spacing, radius, and component patterns
  from ui-ux-pro-max and the chosen style skill.
- Write a project **`DESIGN.md`** in the generated project using the format in
  `taste-suite/stitch-skill/SKILL.md` (atmosphere, color roles + hex, type,
  components, layout, motion, banned anti-patterns). Mirror the key choices into
  `demonlist.config.json`.
- This DESIGN.md is the single source of truth for every screen. Every screen
  must obey it.

## STEP 5 — Build, then SELF-AUDIT (the gate)
Build each surface strictly from DESIGN.md and the chosen style skill. Then run
the chosen style skill's own checklist AND this universal anti-slop audit. If
ANY box fails, fix it before showing the user — do NOT ship slop.

- [ ] I actually read the core taste-skill + the chosen style skill files.
- [ ] No banned fonts (no Inter/Roboto/Arial/Open Sans for premium contexts).
- [ ] No default AI purple/blue gradient and no neon outer glows.
- [ ] No em-dashes anywhere in UI copy; no emojis; no AI cliché copy
      ("Elevate", "Seamless", "Unleash", "Next-Gen").
- [ ] Not pure black `#000000` — use off-black/charcoal.
- [ ] Max ONE accent color, saturation < 80%, repeated consistently.
- [ ] No generic 3-equal-card row; no cards-inside-cards-inside-cards.
- [ ] Real, contextual content — no "John Doe"/"Acme"/Lorem Ipsum, no fake round
      numbers; use realistic GD level/player names.
- [ ] Hover, active, focus, loading, empty, and error states all exist.
- [ ] Motion uses custom easing/spring, only `transform`/`opacity`; respects
      `prefers-reduced-motion`.
- [ ] Collapses cleanly to single column < 768px; `min-h-[100dvh]` not `h-screen`.
- [ ] The result matches DESIGN.md and looks intentional, NOT "AI-made".
- [ ] Output is complete — no truncation, no `// ...`, no "rest follows".

If the user says the result still looks generic, re-open the style skill, find
which bans you violated, and fix them specifically — do not just tweak colors.
