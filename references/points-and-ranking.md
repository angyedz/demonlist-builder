# Points & Ranking

The scoring engine turns approved records into player points and a leaderboard.
It is configurable (see `templates/demonlist.config.json`) so one engine serves
any list. Default to the "mixed" model below.

## Core idea

Each level grants points based on its `position`. A player earns:
- full points for a verified completion (progress = 100), and
- partial points for a qualifying record (progress >= level.requirement).
A player's total = sum over their best record per level.

## Position -> points (decay curve)

Harder (lower position) levels are worth more, with smooth decay:

```
points(pos) = MAX * exp(-k * (pos - 1))   clamped to >= FLOOR within list
```

- MAX: points for position 1 (e.g. 250).
- k: decay rate; tune so position ~150 lands near FLOOR (e.g. 10-19).
- FLOOR: minimum points a listed level grants (0 past the list end).
- This reproduces the "#1 ~250 down to ~10" curve of real lists.

## Partial (list percent) credit

For progress p where requirement <= p < 100:
```
partial(pos, p) = points(pos) * scale(p)
```
- `scale(p)` is a config curve (linear from requirement->100, or stepped).
- Many lists only award partial credit on the Main division.

## Divisions (full-stack)

- main / extended / advanced / unbounded: each division can have its own MAX, k,
  and whether partial credit applies. Configure per division.

## Mixed model (default)

Combine: exponential position decay + division multipliers + optional pack
bonuses + partial list-percent credit. All toggled in config so a static list
can use a simpler subset while a full-stack list uses everything.

## Computing the leaderboard

1. For each player, take best approved record per level.
2. Sum points (full or partial) + pack bonuses.
3. Order desc; assign rank (ties share rank).
- Relational: window function `RANK() OVER (ORDER BY total DESC)`.
- Document/Firestore: recompute on write or via scheduled job; store total.

## Recompute triggers

Recompute affected players when: a record is approved/rejected, a level moves
position, a level is added/removed, or config changes.
