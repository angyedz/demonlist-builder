# Canonical Data Model

Database-agnostic entity set. Keep these entities and fields stable across every
adapter; only the storage syntax changes.

## Entities

### level (a.k.a. demon)
- id (pk)
- name
- position (int, 1 = hardest; unique, drives the ordering)
- publisher_id -> player.id (creator/holder shown on the list)
- verifier_id -> player.id
- video_url (verification video)
- level_id_ingame (GD level ID, optional)
- requirement (min % to qualify for a record on this level)
- list_division (enum: main | extended | advanced | unbounded | legacy)
- created_at, updated_at

### player
- id (pk)
- name (unique, case-insensitive)
- nationality (ISO country code, optional)
- banned (bool)
- A player is a GD player; NOT necessarily a site account (see user).

### record
- id (pk)
- level_id -> level.id
- player_id -> player.id
- progress (int %, 100 = completion)
- video_url
- status (enum: approved | pending | rejected | under_consideration)
- submitter_id -> user.id (nullable)
- created_at

### user (site account)
- id (pk)
- username, password_hash / oauth
- role (enum: admin | moderator | helper | member)
- linked_player_id -> player.id (nullable; claim system)

### list_pack (optional, TSL-style)
- id, name, color, levels[] -> level.id, bonus_points

### audit_log
- id, actor_user_id, action, entity, entity_id, before, after, created_at

## Invariants

- `position` is contiguous and unique within a list; moving a level reorders the
  others. Store moves in audit_log.
- A record counts toward points only when status = approved and progress meets
  the level requirement.
- player vs user are separate; merging happens via linked_player_id (claims).
