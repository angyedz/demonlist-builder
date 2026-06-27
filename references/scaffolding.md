# Scaffolding Guide

Concrete build steps once archetype + database are chosen. The agent picks the
actual framework that best fits the request; the steps below are stack-neutral.

## Shared setup

1. Copy `templates/demonlist.config.json` into the new project and edit it.
2. Keep the adapter contract from `database-adapters.md` as the only DB boundary.
3. Reuse `scripts/points_engine.py` (or port it) for scoring + leaderboard.

## Static-JSON build

1. Copy `templates/static-json/` into the project (`_list.json` + `data/`).
2. Add one `data/<slug>.json` per level; position = index in `_list.json`.
3. Frontend (any SPA or SSG) fetches `_list.json`, then each level file.
4. Compute leaderboard client-side with the points engine logic.
5. Submissions -> form posting to a webhook / GitHub PR. Deploy to static host.

## Full-stack build

1. Provision the DB; run the matching file in `scripts/schema/`
   (postgres.sql / sqlite.sql; adapt for MySQL/Mongo/Firestore/Supabase).
2. Implement the adapter contract over that DB.
3. Build an API: list, level detail, leaderboard, submit, moderate, auth.
4. Recompute points on the triggers in `points-and-ranking.md`.
5. Build the frontend against the API. Seed sample data; run; verify.

## No-code / embed build

1. Put levels/records in a spreadsheet matching the data model columns.
2. Generate or embed a site; map sheet rows to the list/leaderboard views.

## Verification checklist (all archetypes)

- [ ] List renders in correct position order.
- [ ] Leaderboard totals match a hand-checked example.
- [ ] A new record can be submitted and (full-stack) approved.
- [ ] Moving a level reorders positions and recomputes points.
- [ ] Switching the `database` in config requires no frontend changes.
