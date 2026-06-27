# Security (mandatory for non-static builds)

Security is a first-class requirement, not an afterthought. Treat every input as
hostile. Apply this to Full-stack and any no-code-with-backend build. For
Static-JSON, apply the relevant subset (secrets, deploy, dependency, video).

## Threat model first

Before coding, write down: who are the actors (anon, member, helper, moderator,
admin), what assets matter (accounts, records integrity, points, audit log),
and the top abuse cases (fake records, privilege escalation, leaderboard
tampering, account takeover, spam). Build controls against each.

## AuthN / AuthZ

- Passwords: argon2id (or bcrypt cost >= 12). Never store plaintext or reversible.
- Prefer OAuth / Supabase Auth when available to offload credential handling.
- Sessions: httpOnly + Secure + SameSite=Lax/Strict cookies, short TTL, rotate
  on login, server-side revocation. If JWT: short-lived access + refresh, signed
  (asymmetric preferred), validate `aud`/`iss`/`exp`.
- Authorize on the SERVER for every privileged action via the role matrix in
  `admin-panel.md`. Never trust client-sent role/ids. Use object-level checks
  (the user owns/may act on THIS record), not just role checks (avoid IDOR).
- 2FA (TOTP) for moderator/admin. Re-auth before destructive ops.
- Lockout / exponential backoff on failed logins.

## Input validation & injection

- Validate + normalize every input against a strict schema (type, length, range,
  enum). Reject unknown fields.
- SQL: parameterized queries / prepared statements ONLY. Never string-concat.
  ORM is fine if it parameterizes. NoSQL: guard against operator injection
  (reject keys starting with `$`/`.`).
- Output-encode everything rendered (prevent stored XSS from names/video URLs).
- Validate video URLs against an allowlist of hosts (youtube/youtu.be/etc.) and
  parse, do not embed arbitrary HTML/iframes.

## Web hardening

- CSRF tokens on all state-changing requests (or strict SameSite + origin check).
- Strict CORS allowlist; no wildcard with credentials.
- Security headers: CSP (no inline scripts), HSTS, X-Content-Type-Options,
  X-Frame-Options/frame-ancestors, Referrer-Policy.
- HTTPS everywhere; redirect HTTP.
- Rate limit auth, submission, and search endpoints; add captcha on signup/submit.

## Data & secrets

- Secrets in env / secret manager, never in the repo or client bundle. Provide
  `.env.example` only. Rotate leaked keys.
- Least-privilege DB credentials; separate read/write where practical.
- Enable Row Level Security on Supabase / security rules on Firestore: public
  read of approved data only; writes gated by role.
- Backups + tested restore. Encrypt backups. PII (emails) minimized + protected.

## Integrity of the list

- All privileged mutations are transactional and written to an immutable audit
  log (actor, action, before, after, ip, timestamp).
- Points recompute is server-authoritative; never accept client-computed totals.
- Anti-cheat: raw-footage requirement above a progress threshold, duplicate and
  banned-player checks, manual review flags (see `moderation.md`).

## Supply chain & ops

- Pin dependencies; run audit (npm/pip audit) in CI; enable Dependabot.
- No `eval`, no dynamic require of user input. Lint + SAST in CI.
- Centralized error handling: log details server-side, return generic messages
  to clients (no stack traces / SQL in responses).
- Monitoring + alerting on auth failures, 4xx/5xx spikes, and audit anomalies.

## Pre-launch security checklist

- [ ] Threat model written and controls mapped.
- [ ] All privileged routes enforce role + object-level authz server-side.
- [ ] No IDOR: tested accessing others' resources by id.
- [ ] Parameterized queries everywhere; injection tests pass.
- [ ] XSS tested on player names, level names, video URLs.
- [ ] CSRF + CORS + security headers + HTTPS verified.
- [ ] Rate limiting + captcha on auth/submit.
- [ ] Secrets out of the repo; RLS/rules enabled; backups tested.
- [ ] Audit log immutable and covers every privileged action.
- [ ] Dependency audit clean; no secrets in client bundle.
