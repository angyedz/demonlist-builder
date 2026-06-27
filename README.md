# demonlist-builder

A portable **Agent Skill** that lets coding agents (Claude Code, Antigravity,
etc.) design, scaffold, and deploy a Geometry Dash-style **demonlist** — a ranked
list of levels plus a player leaderboard derived from verified records.

The skill is **database-agnostic** and **stack-agnostic**: the agent runs a
thorough discovery interview, picks the archetype and database that fit the
request, and generates a working project with scoring, submissions, moderation,
an admin panel with roles, and a security-hardened backend.

> Not a runnable app by itself — it is an instruction + reference bundle that an
> AI coding agent reads (`SKILL.md` first) and follows to build your project.

## Why

Demonlists (Pointercrate, AREDL, Global Demonlist, The Shitty List) keep being
rebuilt from scratch. This skill captures the shared data model, scoring math,
moderation rules, admin/role requirements, and security baseline so an agent can
stand one up correctly on any stack instead of reinventing it.

## Key principles

- **Ask before building.** The agent must run the discovery interview
  (`references/intake-questions.md`) and confirm a written spec before writing
  any code. No assumptions.
- **Security is first-class.** For non-static builds the agent applies
  `references/security.md` throughout, not at the end.
- **One model, many databases.** A single canonical data model maps onto
  Postgres, SQLite, MySQL, Supabase, MongoDB, Firebase, or static JSON.
- **Stack chosen per task.** The agent selects the framework that best fits.

## Archetypes

1. **Static-JSON** — no backend; data in a `/data` folder; client-side ranking.
2. **Full-stack + database** — real DB, API, accounts, live leaderboard, admin.
3. **No-code / embed** — spreadsheet-driven, embedded site.
4. **Legacy client-side (jQuery)** — documented for reference; prefer #1.

See `references/archetypes.md` for trade-offs and the decision shortcut.

## Repository layout

```
demonlist-builder/
├─ SKILL.md                 # Entry point: when to use + 10-step workflow
├─ README.md                # This file
├─ INSTALL.md               # Wiring into Claude Code / Antigravity
├─ references/
│  ├─ intake-questions.md   # Mandatory discovery interview (ask first)
│  ├─ archetypes.md         # 4 archetypes + decision shortcut
│  ├─ data-model.md         # Canonical DB-agnostic entity set
│  ├─ database-adapters.md  # Postgres/SQLite/MySQL/Supabase/Mongo/Firebase/static
│  ├─ points-and-ranking.md # Scoring curve, partial credit, leaderboard
│  ├─ moderation.md         # Submission flow, skips, anti-cheat
│  ├─ admin-panel.md        # Admin panel + role matrix (non-static)
│  ├─ security.md           # Security baseline + pre-launch checklist
│  └─ scaffolding.md        # Build steps per archetype
├─ scripts/
│  ├─ points_engine.py      # Portable scoring + leaderboard engine
│  └─ schema/
│     ├─ postgres.sql
│     └─ sqlite.sql
└─ templates/
   ├─ demonlist.config.json # Mixed-model scoring/config template
   └─ static-json/          # Static archetype example (_list.json + data/)
```

## How an agent uses it

1. Reads `SKILL.md` and matches the user's request to the skill.
2. Runs the discovery interview (`references/intake-questions.md`), asking as
   many questions as needed and confirming a written spec.
3. Picks archetype + database; locks the data model.
4. Provisions the DB using `scripts/schema/` and the adapter contract.
5. Implements scoring (`scripts/points_engine.py` as reference), submissions,
   moderation, and — for non-static — the admin panel + roles.
6. Hardens security per `references/security.md`.
7. Generates the frontend, seeds data, runs, and verifies.

## Workflow at a glance

| # | Step | Reference |
|---|------|-----------|
| 1 | Discovery (mandatory) | intake-questions.md |
| 2 | Pick archetype | archetypes.md |
| 3 | Lock data model | data-model.md |
| 4 | Provision database | database-adapters.md, scripts/schema/ |
| 5 | Scoring + ranking | points-and-ranking.md, scripts/points_engine.py |
| 6 | Submission + moderation | moderation.md |
| 7 | Admin panel + roles (non-static) | admin-panel.md |
| 8 | Harden security (non-static) | security.md |
| 9 | Frontend | archetypes.md, scaffolding.md |
| 10 | Seed, run, verify | scaffolding.md, security.md |

## Data model (summary)

Entities: `level` (position, requirement, division, verifier/publisher),
`player`, `record` (progress, status), `user` (account + role), `list_pack`,
`audit_log`. Players (GD players) and users (site accounts) are separate and
linked via a claim system. Full details in `references/data-model.md`.

## Scoring (summary)

Points decay by list position (`points(pos) = MAX * exp(-k*(pos-1))`), with
optional partial "list percent" credit, per-division multipliers, and pack
bonuses — all toggled in `templates/demonlist.config.json`. The leaderboard is
server-authoritative. Try the engine:

```bash
python3 scripts/points_engine.py templates/demonlist.config.json data.json
```

## Security (summary)

For non-static builds: server-side authz with object-level checks (anti-IDOR),
parameterized queries, strict input validation, XSS/CSRF/CORS protection,
security headers, secrets out of the repo, RLS / security rules, rate limiting +
captcha, an immutable audit log, and dependency auditing. A full pre-launch
checklist lives in `references/security.md`.

## Install

Symlink (single source of truth) or copy into your agent's skills folder:

```bash
# Claude Code (personal)
ln -s "$PWD" ~/.claude/skills/demonlist-builder

# Antigravity
ln -s "$PWD" ~/.antigravity-ide/skills/demonlist-builder
```

Then trigger with: "build me a demonlist" / "scaffold a GD list on <database>".
See `INSTALL.md` for project-scoped installs and details.

## Contributing

- Keep `references/data-model.md` the single source of truth; adapters must
  conform to it.
- When adding a database, add a `scripts/schema/<engine>.sql` (or rules file)
  and a section in `references/database-adapters.md`.
- Keep `SKILL.md` workflow steps and reference filenames in sync.

## License

MIT — see `LICENSE` (add one before publishing).

## Credits

Patterns derived from public demonlists: Pointercrate, AREDL, Global Demonlist,
and The Shitty List. This skill is an independent, framework-neutral synthesis.
