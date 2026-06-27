# Intake & Discovery (ask before you build)

RULE: Do NOT scaffold anything until you understand the requirements. Ask as
many questions as needed, in small batches, and keep asking follow-ups until
there is zero ambiguity. It is always better to ask one more question than to
guess. Restate your understanding and get explicit confirmation before building.

## How to run discovery

1. Ask in small, focused batches (3-6 questions), grouped by topic below.
2. Use the user's answers to ask sharper follow-ups; drill into anything vague.
3. If an answer implies risk (auth, payments, PII, public writes), branch into
   the security questions and do not skip them.
4. Offer sensible defaults, but still confirm them — never assume silently.
5. When you think you are done, write a short spec summary and ask: "Did I get
   this right, and is anything missing?" Only build after a clear yes.
6. If the user says "just decide" / "you choose", still confirm the few choices
   that affect security, data integrity, or cost before proceeding.

## 1. Purpose & scope

- What is this list for (game, category, community size, official vs fan)?
- Read-only public list, or accounts + submissions + live leaderboard?
- Expected traffic and number of levels/players/records?
- Who maintains it long-term, and how technical are they?

## 2. Archetype & hosting

- Static-JSON, full-stack + DB, or no-code/embed? (explain trade-offs)
- Where will it be hosted? Any platform constraints (Cloudflare, Vercel, VPS)?
- Budget / free-tier only? Self-hosted or managed?

## 3. Database

- Use an existing database or provision a new one?
- If existing: which engine, and can I see the current schema?
- Preference among Postgres / SQLite / MySQL / Supabase / Mongo / Firebase?
- Any data to migrate/import? In what format?

## 4. Data model specifics

- Divisions (main/extended/advanced/unbounded) or a single flat list?
- List length / requirement rules per level?
- Packs/bonuses? Nationalities? player-vs-account (claim) system?

## 5. Scoring & ranking

- Points model: exact curve (MAX/decay), partial "list percent" credit?
- Which divisions award partial credit and pack bonuses?
- How are ties handled? When should points recompute?

## 6. Accounts, roles & moderation

- Auth method: email+password, OAuth, magic link, Supabase Auth?
- Which roles, and exactly what can each do? (confirm the role matrix)
- Submission flow: open to all or members only? Required fields, raw footage?
- Moderation queue, audit log, ban policy?

## 7. Security (always ask for non-static)

- Sensitivity of data / PII collected (emails)? Compliance needs?
- 2FA for staff? Account lockout policy? Rate limits / captcha needed?
- Allowed video hosts? How strict on anti-cheat (raw footage threshold)?
- Who holds secrets/keys? Backup & recovery expectations?
- Any past abuse/attacks to defend against specifically?

## 8. Frontend & UX

- Design/brand constraints, theming, dark mode, multilingual?
- Pages needed: list, level detail, leaderboard, packs, roulette, submit, admin?
- Mobile priority? Accessibility requirements?

## 9. Delivery & ops

- Deadline / milestones? CI/CD? Monitoring & alerting?
- Who deploys and maintains it after handoff?

## Definition of "ready to build"

You may start only when ALL are true:
- [ ] Archetype, database, and hosting are confirmed.
- [ ] Data model and scoring model are unambiguous.
- [ ] Roles, auth, and moderation flow are confirmed (non-static).
- [ ] Security expectations are captured (non-static).
- [ ] A written spec summary has been confirmed by the user.
If any box is unchecked, ask more questions instead of building.
