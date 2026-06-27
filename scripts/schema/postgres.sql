-- Demonlist schema (PostgreSQL). Mirrors references/data-model.md.

CREATE TYPE list_division AS ENUM ('main','extended','advanced','unbounded','legacy');
CREATE TYPE record_status AS ENUM ('approved','pending','rejected','under_consideration');
CREATE TYPE user_role     AS ENUM ('admin','moderator','helper','member');

CREATE TABLE player (
  id           BIGSERIAL PRIMARY KEY,
  name         TEXT NOT NULL UNIQUE,
  nationality  TEXT,
  banned       BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE app_user (
  id               BIGSERIAL PRIMARY KEY,
  username         TEXT NOT NULL UNIQUE,
  password_hash    TEXT,
  role             user_role NOT NULL DEFAULT 'member',
  linked_player_id BIGINT REFERENCES player(id)
);

CREATE TABLE level (
  id              BIGSERIAL PRIMARY KEY,
  name            TEXT NOT NULL,
  position        INT  NOT NULL UNIQUE,
  publisher_id    BIGINT REFERENCES player(id),
  verifier_id     BIGINT REFERENCES player(id),
  video_url       TEXT,
  level_id_ingame BIGINT,
  requirement     INT NOT NULL DEFAULT 100 CHECK (requirement BETWEEN 1 AND 100),
  list_division   list_division NOT NULL DEFAULT 'main',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE record (
  id           BIGSERIAL PRIMARY KEY,
  level_id     BIGINT NOT NULL REFERENCES level(id) ON DELETE CASCADE,
  player_id    BIGINT NOT NULL REFERENCES player(id),
  progress     INT NOT NULL CHECK (progress BETWEEN 1 AND 100),
  video_url    TEXT,
  status       record_status NOT NULL DEFAULT 'pending',
  submitter_id BIGINT REFERENCES app_user(id),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (level_id, player_id)
);

CREATE TABLE list_pack (
  id           BIGSERIAL PRIMARY KEY,
  name         TEXT NOT NULL,
  color        TEXT,
  bonus_points NUMERIC NOT NULL DEFAULT 0
);

CREATE TABLE pack_level (
  pack_id  BIGINT REFERENCES list_pack(id) ON DELETE CASCADE,
  level_id BIGINT REFERENCES level(id)     ON DELETE CASCADE,
  PRIMARY KEY (pack_id, level_id)
);

CREATE TABLE audit_log (
  id            BIGSERIAL PRIMARY KEY,
  actor_user_id BIGINT REFERENCES app_user(id),
  action        TEXT NOT NULL,
  entity        TEXT NOT NULL,
  entity_id     BIGINT,
  before        JSONB,
  after         JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_record_level  ON record(level_id);
CREATE INDEX idx_record_player ON record(player_id);
CREATE INDEX idx_level_pos     ON level(position);
