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

- **Speak the user's language.** Ask every question, write every summary, and
  explain everything in the SAME language the user writes to you in. Mirror it
  exactly and switch if they switch. Never default to English. (Code keywords
  stay in English; all human-facing prose does not.) See the LANGUAGE RULE in
  `references/intake-questions.md`.
- **Ask before you build.** Never scaffold on assumptions. Run a full discovery
  pass using `references/intake-questions.md`, asking as many questions as
  needed, in small batches, with follow-ups, until there is zero ambiguity.
  Restate a written spec and get explicit confirmation before building.
- **Design is not optional.** Default AI output looks generic and "AI-made".
  Before generating any frontend, run the Design phase: the full questionnaire
  in `references/frontend-questions.md` and the process in
  `references/design-system.md` (which wires in the embedded taste-skill and
  ui-ux-pro-max design skills under `references/design/`). No frontend may be
  generated until the design is decided with the user.
- **Offer the full feature set.** Don't ship a bare list. During discovery,
  walk the user through `references/features.md` (player profiles & claims,
  nationalities, packs/bonuses, roulette, time machine/position history,
  search/filter, public API, changelog/news, Discord webhooks, notifications,
  staff stats) and build the ones they want.
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
9. **Design phase (mandatory before any frontend).** Run
    `references/frontend-questions.md` end to end in the user's language — ask
    about the list layout, record/progress bars, badges/medals, divisions/tabs,
    leaderboard columns, level-detail page, nav/shell, theme tokens
    (color/type/radius/density/motion), branding, responsive, and a11y. Then
    follow `references/design-system.md`: produce a Design Read, lock the 3
    dials (taste-skill), pull concrete patterns/palettes/type from
    ui-ux-pro-max, and write the choices into `demonlist.config.json` + a
    project `DESIGN.md`. Do NOT generate any UI until the ready-to-design gate
    is fully checked.
10. **Generate the frontend** for the chosen archetype, strictly following the
    locked design system. Apply taste-skill's AI-tells bans the whole way (no
    default purple, no em-dashes, no cookie-cutter card grids). Then run the
    taste-skill pre-flight checklist before declaring the frontend done.
11. **Seed, run, verify.** Load sample data, start the app, confirm list +
    leaderboard render and a record can be submitted. Then run the security
    pre-launch checklist in `references/security.md`.
