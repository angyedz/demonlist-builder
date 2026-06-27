# Admin Panel & Roles (non-static only)

Required for Full-stack and No-code-with-backend builds. Skip for Static-JSON
(there is no server to authorize against; edits happen via git/PR instead).

## Auth & sessions

- Login + logout, hashed passwords (argon2/bcrypt) or OAuth/Supabase Auth.
- Server-side sessions or signed JWTs; CSRF protection on all mutating routes.
- Every privileged route checks role server-side, never trust the client.
- Optional 2FA for admin/moderator.

## Role matrix

| Capability                         | member | helper | moderator | admin |
|------------------------------------|:------:|:------:|:---------:|:-----:|
| Submit record / claim player       |   x    |   x    |     x     |   x   |
| View submission queue              |        |   x    |     x     |   x   |
| Approve / reject records           |        |        |     x     |   x   |
| Add / edit / reorder levels        |        |        |     x     |   x   |
| Edit / merge / ban players         |        |        |     x     |   x   |
| Manage packs                       |        |        |     x     |   x   |
| Manage users & assign roles        |        |        |           |   x   |
| Edit list config / scoring         |        |        |           |   x   |
| View audit log                     |        |   x    |     x     |   x   |
| Destructive ops (delete, purge)    |        |        |           |   x   |

Keep roles in sync with `demonlist.config.json` `moderation.roles`.

## Admin panel sections

1. **Dashboard** — counts (levels, players, pending records), recent audit
   entries, recompute-points button.
2. **Submission queue** — filter by status; approve/reject with reason;
   side-by-side video + level requirement; bulk actions.
3. **Levels** — CRUD + drag-to-reorder (writes new positions in a transaction
   and triggers points recompute); set requirement, division, video.
4. **Players** — search, edit, ban/unban, merge duplicates, link to user.
5. **Packs** — create/edit packs, assign levels, set bonus points.
6. **Users & roles** — invite, set role, deactivate (admin only).
7. **Config** — edit scoring curve, divisions, partial credit; preview the
   leaderboard impact before saving.
8. **Audit log** — filter by actor/entity/action; immutable; export.

## Backend requirements driven by the panel

- Authorization middleware mapping route -> minimum role (the matrix above).
- Audit logging on every privileged mutation (actor, action, before, after).
- Transactional reorder + points recompute on approve/reject/reorder/config.
- Soft-delete + restore for levels/records where possible; hard-delete is admin.
- Rate limiting on auth + submission endpoints.

## Verification checklist

- [ ] A helper cannot approve records or edit levels (403 server-side).
- [ ] A moderator cannot change roles or edit scoring config.
- [ ] Approving a record recomputes the player's points.
- [ ] Reordering levels updates positions atomically and is logged.
- [ ] Every privileged action appears in the audit log.
