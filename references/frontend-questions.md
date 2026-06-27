# Frontend & Design Questionnaire

The agent MUST work through this BEFORE generating any frontend. Ask in the
user's language (see the language rule in `intake-questions.md`). Ask in small
batches, confirm answers, and keep asking follow-ups until EVERY surface below is
fully specified. Never assume a default silently "to save time" — if the user
says "you decide", propose 2–3 concrete options and let them pick.

Whenever the user is unsure, pull real options from ui-ux-pro-max:
`python3 references/design/ui-ux-pro-max/scripts/search.py "<query>" --design-system`

## 0. Aesthetic direction + STYLE SKILL (do this first)
- What feeling should the site give (e.g. competitive/esports, brutalist,
  retro-arcade, clean editorial, dark "hacker", playful)? Give 2–3 reference
  sites or screenshots.
- **Pick the style skill** (see `design-system.md` Step 2). Present the options
  and recommend one, then commit to it:
  - `industrial-brutalist-ui` (brutalist-skill) — raw tactical/CRT or Swiss-print,
    huge type, mono data, hazard-red. Strong default for a hardcore GD list.
  - `high-end-visual-design` (soft-skill) — premium agency: OLED dark,
    double-bezel cards, spring motion, Awwwards polish.
  - `minimalist-ui` (minimalist-skill) — clean editorial, warm monochrome,
    flat bento, muted pastels.
  Confirm which one BEFORE asking the rest — it changes every later answer.
- Do they want a logo / brand kit? If yes, run `brandkit` first.
- Dark mode, light mode, or both? Which is default?
- Dials: DESIGN_VARIANCE / MOTION_INTENSITY / VISUAL_DENSITY — propose a baseline
  from the chosen style skill and confirm per-surface adjustments.
- Should the agent generate reference IMAGES first (image-to-code / imagegen)
  before coding, so the build matches a real visual target?

## 1. The list (main demonlist view)
- Cards or rows? One column, or a grid? How many items per page / infinite scroll?
- What goes on each entry: position number style (#1 vs 01 vs medal),
  thumbnail/level-image, level name, creator/verifier, difficulty face,
  points, video preview on hover?
- How prominent is the #1? Special hero treatment for the top 3?
- Show requirement %, victors count, and a record/progress bar on the row?

## 2. Bars (record / progress visualization)
- Do levels/players have progress bars at all? Where (row, level page, profile)?
- Bar style: solid fill, gradient, segmented/stepped, striped, animated fill on
  load? Rounded or square ends? Height/thickness?
- What does the bar encode — verification %, list completion %, player
  list-percent? Show the number inside, beside, or on hover?
- Color logic: single accent, or color-by-difficulty / color-by-threshold
  (e.g. red < 60%, green = 100%)?

## 3. Badges, medals & ranks
- #1/#2/#3 medals or crowns? Gold/silver/bronze, or custom?
- Difficulty badges (Easy→Extreme Demon faces, or numeric tiers)?
- Role badges next to usernames (admin/mod/helper)? Country flags?
- Player rank tiers / titles based on points (e.g. "Beginner→Legend")?

## 4. Divisions & tabs
- Main / Extended / Legacy split? Any extra divisions (Platformer, Challenge,
  Speedhack, etc.)?
- Tabs, a dropdown, or separate pages? Which is default on load?
- Per-division point rules shown anywhere?

## 5. Leaderboard
- Columns: rank, player, points, hardest, #completed, country, last activity?
- Avatars? Flags? Clickable to player profile?
- Row striping / hover highlight / sticky header? Pagination or infinite scroll?
- Highlight the current user's own row?

## 6. Level detail page
- Layout: video embed on top, or side-by-side with stats? Fallback when a video
  is unavailable (the Gemini build showed a bare "Видео недоступно" placeholder —
  what should ours look like)?
- Stats block: position, points, requirement, creator(s), verifier, level ID,
  song, publish date.
- Records/victors table: columns, sort, progress bar, video link per record,
  flags/avatars. Show submit-record CTA here?

## 7. Navigation & shell
- Sidebar, top nav, or both? Which items (List, Leaderboard, Packs, Submit,
  Profile, Staff Panel, About/Rules)?
- Logo/branding in the corner? Search bar in the shell?
- Mobile: hamburger, bottom tab bar, or collapsible sidebar?

## 8. Theme tokens
- Primary/accent color(s) — give hex or a vibe (and avoid the default AI purple
  unless intended; see taste-skill LILA RULE).
- Background: pure black, near-black, deep navy, off-white?
- Typography: display font for headings + body font (pull pairings from
  ui-ux-pro-max). Mono font for IDs/points?
- Corner radius (sharp→pill), border vs shadow style, spacing density.
- Motion: hover effects, page transitions, bar-fill animation, count-ups — how
  much (tie to MOTION_INTENSITY)?

## 9. Branding & content
- Site name, logo (have one, or generate?), favicon, social/OG image.
- Tone of copy (serious/competitive vs playful). Language(s) of the UI itself.
- Rules/guidelines page, about page, credits/staff page — needed?

## 10. Responsive & accessibility
- Target breakpoints (desktop-first or mobile-first)? How should the list/table
  collapse on mobile (cards, horizontal scroll, hidden columns)?
- Contrast/readability requirements; respect `prefers-reduced-motion`?
- Keyboard navigation and focus states for tables, tabs, and the admin panel.

## 11. Stack & delivery (frontend)
- Framework preference (or let the agent pick per the archetype): SvelteKit,
  Next/React, Vue, Astro, or static-JSON + vanilla?
- Component library or fully custom? Tailwind, CSS modules, or plain CSS?
- Static export vs SSR? Where is it hosted?

---

## Ready-to-design gate
Do NOT scaffold the frontend until you can fill in, in the user's words:
- [ ] Aesthetic direction + dials locked
- [ ] List layout (cards/rows) + entry contents decided
- [ ] Bars style + meaning decided (or confirmed: no bars)
- [ ] Badges/medals/flags decided
- [ ] Divisions + tabs decided
- [ ] Leaderboard columns decided
- [ ] Level-detail layout decided
- [ ] Nav/shell decided
- [ ] Theme tokens (color/type/radius/density/motion) decided
- [ ] Responsive + a11y expectations decided
- [ ] Frontend stack decided

When every box is checked, write the choices into `demonlist.config.json` and a
project `DESIGN.md`, then begin the Design phase build.
