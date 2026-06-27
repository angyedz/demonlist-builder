# Submission & Moderation

How records enter the list and how staff keep it clean.

## Submission flow

1. Submitter sends: level, player name, progress %, video URL, (raw footage,
   device, refresh rate) for hard records.
2. Record is created with status = pending (full-stack) or queued to a
   webhook/PR (static-JSON).
3. A moderator reviews and sets status: approved | rejected |
   under_consideration.
4. On approval, trigger a points recompute for that player.

## Validation rules

- progress must be an int, requirement <= progress <= 100.
- video_url must be a real, reachable video; reject private/deleted.
- Reject duplicates (same player + level with >= progress already approved).
- Banned players cannot hold records; their submissions auto-reject.

## Moderation skips (Pointercrate-style)

When a level is removed/added, records may be silently handled:
- Type I: progress no longer qualifies -> record dropped.
- Type II: level left the list -> records archived, points removed.
- Type III: requirement changed -> re-check each record against new requirement.
Log every skip in audit_log.

## Anti-cheat signals

- Require raw footage above a progress threshold (config).
- Flag impossible CPS / physics-bypass / TPS hacks for manual review.
- Compare verification video creator vs claimed player.

## Roles & permissions

- member: submit records, claim a player.
- helper: review the submission queue, no list edits.
- moderator: approve/reject, reorder levels, edit players.
- admin: manage users/roles, config, destructive ops.
- Every privileged action writes to audit_log (actor, before, after).
