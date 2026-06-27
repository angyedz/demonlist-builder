# Database Adapters

Map the canonical model (`data-model.md`) onto the chosen backend. Always reuse
an existing DB if the user points to one; otherwise provision a new one.

## Choosing

- PostgreSQL: default for full-stack. Strong constraints, window funcs for ranks.
- SQLite: single-file, great for self-host / small lists / local dev.
- MySQL/MariaDB: when the user's host mandates it.
- Supabase: Postgres + auth + REST/Realtime; fastest path to full-stack.
- MongoDB: document model; embed records under levels if read-heavy.
- Firebase (Firestore): serverless, realtime, good for no-server full-stack.
- Static JSON: no DB; the `/data` folder IS the store (archetype 1).

## Relational (Postgres / SQLite / MySQL)

- One table per entity; FKs as in the model. Schemas in `scripts/schema/`.
- Compute ranks with window functions or an ORDER BY + offset.
- Use transactions for position reorders and record approval.

## Supabase

- Use the Postgres schema as-is. Map `user` to `auth.users`; put profile fields
  in a `profiles` table keyed by auth uid. Add Row Level Security: public read
  on level/record(approved)/player; writes restricted to moderator+ roles.

## MongoDB

- Collections: levels, players, records, users, packs, audit_log.
- Denormalize verifier/publisher names onto level for fast list reads; keep
  player as source of truth. Maintain points via an aggregation pipeline or a
  scheduled recompute, since there are no FKs/joins by default.

## Firebase / Firestore

- Collections mirror MongoDB. Use security rules instead of RLS.
- Realtime listeners drive live leaderboards. Recompute points in a Cloud
  Function on record write, or store denormalized player.points.

## Static JSON

- `data/_list.json`: ordered array of level slugs (position = array index + 1).
- `data/<slug>.json`: level fields + embedded records array.
- No users table; submissions go to a form -> webhook. Points computed at
  build/runtime by the client.

## Adapter contract

Whatever the backend, expose the same operations to the rest of the app:
`listLevels`, `getLevel`, `listRecords`, `submitRecord`, `approveRecord`,
`reorderLevel`, `getLeaderboard`, `getPlayer`. Keep this interface identical so
the frontend and scoring engine never change when the DB changes.
