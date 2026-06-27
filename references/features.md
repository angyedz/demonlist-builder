# Extra Features (backend functionality)

Beyond the core list + leaderboard + records, offer these during discovery and
implement the ones the user wants. Each must be server-authoritative and pass
the security rules in `security.md`. Always ASK whether the user wants each one
(in their language) rather than assuming.

## Player & community
- **Player profiles**: hardest demon, total points, rank, completed levels,
  records timeline, nationality/flag, social links.
- **Account ↔ player claims**: a user claims a player entity (verified by a
  staff member or a code in a video description); points follow the player.
- **Nationalities & country leaderboards**: per-country ranking and flags.
- **Player search + filters**: by name, country, point range, hardest demon.

## List mechanics
- **List packs + bonuses**: grouped levels that award bonus points on full
  completion; pack progress per player.
- **Divisions / sub-lists**: main, extended, legacy, platformer, challenge, etc.
  with per-division scoring rules.
- **Roulette**: random-level challenge generator with a saved run/session and
  progress tracking.
- **Time machine / position history**: store every position change so the list
  state at any past date can be shown; per-level history graph.

## Discovery & data access
- **Search / filter / sort** across levels and players (by difficulty, creator,
  verifier, points, division, date).
- **Public read API** (versioned, rate-limited, documented) so others can build
  bots/overlays on top of the list.
- **Export / import**: JSON/CSV export of the list and leaderboard; import for
  migrations.

## Staff & ops
- **Changelog / news feed**: announcements and an automatic list-change log
  (placements, raises, drops) shown publicly.
- **Discord webhooks / bot**: post placements, accepted/denied records, and news
  to a server. Per-event toggles.
- **Notifications**: notify a user when their record is accepted/denied.
- **Stats dashboard (staff)**: submissions volume, acceptance rate, active
  players, growth over time.

## Implementation notes
- Every feature that writes data goes through the same authz + validation +
  audit-log path as core records (see `security.md` and `admin-panel.md`).
- Position history and the changelog should be written transactionally whenever
  a level's position changes, so the time machine and news feed stay accurate.
- Recompute points after any change that affects ordering, packs, or divisions;
  keep recomputation idempotent and server-side.
- Gate expensive endpoints (search, API, time machine) with caching and rate
  limits.
