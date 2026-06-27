# Demonlist Archetypes

Four archetypes derived from real lists. Pick one, then map it to a database in
`database-adapters.md`.

## 1. Static-JSON (no backend)

Reference: The Shitty List (Vue 3 + Vue Router on Cloudflare Pages).

- Data lives in a `/data` folder: one `_list.json` (ordered slugs) + one JSON
  file per level (`data/<slug>.json`) with verifier, records, video.
- Leaderboard + points computed **client-side** at build/runtime from the JSON.
- Submissions handled via a form -> webhook/Discord/PR, not a live DB.
- Pros: free hosting, no server, git-versioned, trivial to fork.
- Cons: no live accounts, edits require redeploy, weak moderation.
- Best for: small/medium community lists, challenge lists, fan lists.

## 2. Full-stack + database

Reference: Global Demonlist (SvelteKit + API), Pointercrate (Rust + Postgres).

- Real DB holds levels, players, records, users, submitters.
- Server computes/serves points, leaderboards, divisions, history.
- Accounts + roles, audit log, record submission queue with moderation.
- Pros: live updates, real auth, scalable, divisions/time-machine.
- Cons: needs hosting + DB + maintenance.
- Best for: official lists, large communities, competitive leaderboards.

## 3. No-code / embed

Reference: Google Sites + Sheets + YouTube embeds.

- Data in a spreadsheet; site is generated/embedded; videos via YouTube API.
- Pros: zero code, anyone can edit the sheet.
- Cons: no real ranking engine, limited UX, hard to scale.
- Best for: prototypes, private/club lists, quick starts.

## 4. Legacy client-side (jQuery)

Reference: older jQuery + jQuery UI list.

- Static HTML + jQuery rendering a hardcoded/JSON list. Functionally a less
  structured Static-JSON. Prefer archetype 1 for new builds.

## Decision shortcut

- Need accounts, live leaderboard, moderation queue? -> Full-stack + DB.
- Public read-only ranked list, community-maintained via git? -> Static-JSON.
- Non-technical owner, must edit without code? -> No-code/embed.
