---
name: demonlist-builder
description: Use when the user wants to create, scaffold, or deploy a Geometry Dash demonlist (or any ranked level + player-leaderboard site). Builds the data model, the chosen database (PostgreSQL, SQLite, MySQL, MongoDB, Supabase, Firebase) or a static-JSON backend, the scoring/ranking engine, record submission + moderation, and a frontend. Picks the stack and archetype that best fit the request.
---

# Demonlist Builder

Scaffold and deploy a Geometry Dash-style demonlist end to end. A demonlist is a
ranked list of levels plus a player leaderboard derived from verified records.

This skill is database-agnostic and stack-agnostic: choose the archetype and DB
that match the user's needs, then generate a working project.

## When to use

- "Make me a demonlist", "build a GD list site", "clone pointercrate/AREDL/TSL".
- Deploy or migrate a list onto a specific database.
- Add scoring, leaderboards, record submission, or moderation to a list.

## Core principles

- **Ask before you build.** Never scaffold on assumptions. Run a full discovery
  pass using `references/intake-questions.md`, asking as many questions as
  needed, in small batches, with follow-ups, until there is zero ambiguity.
  Restate a written spec and get explicit confirmation before building.
- **Security is first-class.** For any non-static build, treat every input as
  hostile and apply `references/security.md` throughout — not at the end.

## Workflow (follow in order)

1. **Discovery (mandatory).** Use `references/intake-questions.md`. Confirm
   archetype, database, data model, scoring, roles/auth/moderation, security
   expectations, hosting, and delivery. Keep asking until every "ready to
   build" box is checked. Do NOT proceed while anything is ambiguous, even if
   the user says "you decide" — still confirm choices affecting security, data
   integrity, or cost.
2. **Pick the archetype.** See `references/archetypes.md`. Default to Static-JSON
   for simple public lists; Full-stack+DB when records, accounts, or live
   leaderboards are required.
3. **Lock the data model.** Use `references/data-model.md` as the canonical
   entity set. Keep it stable across databases.
4. **Select + provision the database.** Use `references/database-adapters.md`.
   Reuse an existing DB when the user points to one; otherwise provision.
5. **Implement scoring + ranking.** Use `references/points-and-ranking.md`.
6. **Add submission + moderation.** Use `references/moderation.md`.
7. **Build the admin panel + role system** (skip for Static-JSON). Use
   `references/admin-panel.md`: auth, role matrix, authorization middleware,
   submission queue, level/player/pack management, user & role management,
   config editor, and audit log.
8. **Harden security** (mandatory for non-static). Apply `references/security.md`
   throughout: server-side authz + object-level checks, parameterized queries,
   input validation, XSS/CSRF/CORS, security headers, secrets management,
   RLS/rules, rate limiting, immutable audit log, dependency audit.
9. **Generate the frontend** for the chosen archetype.
10. **Seed, run, verify.** Load sample data, start the app, confirm list +
    leaderboard render and a record can be submitted. Then run the security
    pre-launch checklist in `references/security.md`.
