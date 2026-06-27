-- Demonlist schema (SQLite). Mirrors references/data-model.md.
-- Enums are emulated with CHECK constraints. Run with PRAGMA foreign_keys=ON.

PRAGMA foreign_keys = ON;

CREATE TABLE player (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL UNIQUE,
  nationality TEXT,
  banned      INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE app_user (
  id               INTEGER PRIMARY KEY AUTOINCREMENT,
  username         TEXT NOT NULL UNIQUE,
  password_hash    TEXT,
  role             TEXT NOT NULL DEFAULT 'member'
                     CHECK (role IN ('admin','moderator','helper','member')),
  linked_player_id INTEGER REFERENCES player(id)
);

CREATE TABLE level (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  name            TEXT NOT NULL,
  position        INTEGER NOT NULL UNIQUE,
  publisher_id    INTEGER REFERENCES player(id),
  verifier_id     INTEGER REFERENCES player(id),
  video_url       TEXT,
  level_id_ingame INTEGER,
  requirement     INTEGER NOT NULL DEFAULT 100
                     CHECK (requirement BETWEEN 1 AND 100),
  list_division   TEXT NOT NULL DEFAULT 'main'
                     CHECK (list_division IN
                       ('main','extended','advanced','unbounded','legacy')),
  created_at      TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE record (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  level_id     INTEGER NOT NULL REFERENCES level(id) ON DELETE CASCADE,
  player_id    INTEGER NOT NULL REFERENCES player(id),
  progress     INTEGER NOT NULL CHECK (progress BETWEEN 1 AND 100),
  video_url    TEXT,
  status       TEXT NOT NULL DEFAULT 'pending'
                 CHECK (status IN
                   ('approved','pending','rejected','under_consideration')),
  submitter_id INTEGER REFERENCES app_user(id),
  created_at   TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE (level_id, player_id)
);

CREATE TABLE list_pack (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  name         TEXT NOT NULL,
  color        TEXT,
  bonus_points REAL NOT NULL DEFAULT 0
);

CREATE TABLE pack_level (
  pack_id  INTEGER REFERENCES list_pack(id) ON DELETE CASCADE,
  level_id INTEGER REFERENCES level(id)     ON DELETE CASCADE,
  PRIMARY KEY (pack_id, level_id)
);

CREATE TABLE audit_log (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  actor_user_id INTEGER REFERENCES app_user(id),
  action        TEXT NOT NULL,
  entity        TEXT NOT NULL,
  entity_id     INTEGER,
  before        TEXT,
  after         TEXT,
  created_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_record_level  ON record(level_id);
CREATE INDEX idx_record_player ON record(player_id);
CREATE INDEX idx_level_pos     ON level(position);
