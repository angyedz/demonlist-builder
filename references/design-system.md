# Design System (bridge)

This file wires the two embedded design skills into the demonlist workflow so the
agent stops producing generic, "AI-looking" frontends.

Two skills live under `references/design/`:
- **taste-skill** (`design-taste-frontend`): aesthetic direction, anti-AI-slop
  guardrails, the 3 dials, and the AI-tells ban list.
- **ui-ux-pro-max**: concrete UI patterns, color palettes, typography pairings,
  component/layout references, and a CLI search over a curated design database.

## When to use which

Use **taste-skill** when:
- Setting the overall aesthetic direction / writing the "Design Read" one-liner.
- Choosing the 3 dials (DESIGN_VARIANCE / MOTION_INTENSITY / VISUAL_DENSITY).
- Avoiding AI-tells (generic purple gradients, em-dashes, centered-everything,
  identical card grids, glassmorphism-by-default, etc.).
- Running the final pre-flight review before shipping ANY frontend.

Use **ui-ux-pro-max** when:
- You need concrete patterns: card-vs-row layouts, leaderboard tables, tabs,
  badges, level-detail pages.
- You need palettes, font pairings, spacing/density tokens, motion specs.
- Query the CLI:
  `python3 references/design/ui-ux-pro-max/scripts/search.py "<query>" --design-system`
  (add `--domain` / `--stack` to narrow; `--persist -p "Name" --page "x"` to save).

## Important scoping note

taste-skill self-scopes to landing/portfolio/redesign work and lists
dashboards/data-tables as OUT OF SCOPE (it points those to Fluent/Carbon). A
demonlist IS a data-heavy app (leaderboards, dense tables, an admin panel). So:
- Use taste-skill for marketing/hero/branding surfaces and the overall tone.
- For dense data surfaces (the list, leaderboard, admin tables) lean on
  ui-ux-pro-max patterns plus a proven data-table approach, but KEEP
  taste-skill's anti-slop rules and the locked dials applied everywhere.

## One design system per project
- Lock ONE design system before generating any frontend: palette, typography
  scale, spacing/density, radius, motion level, component library.
- Record the decisions in the project's `demonlist.config.json` `design` block
  (and mirror a short `DESIGN.md` in the generated project).
- The dials baseline is 8/6/4; adjust from the user's answers in
  `references/frontend-questions.md`.

## Mandatory order (the Design phase)
1. Run the frontend questionnaire (`references/frontend-questions.md`) in the
   user's language.
2. Produce a Design Read + lock the 3 dials (taste-skill).
3. Pull concrete patterns / palette / type from ui-ux-pro-max.
4. ONLY THEN scaffold the frontend.
5. Run the taste-skill pre-flight checklist before declaring the frontend done.

The agent MUST NOT generate any frontend before steps 1-3 are complete.
