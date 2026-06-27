# Installing the demonlist-builder skill

This skill lives in `~/Documents/demonlist-builder`. Wire it into your coding
agents by copying or symlinking it into their skills folder.

## Claude Code

Personal (all projects):
```bash
mkdir -p ~/.claude/skills
ln -s ~/Documents/demonlist-builder ~/.claude/skills/demonlist-builder
```
Project-scoped (committed with a repo):
```bash
mkdir -p .claude/skills
cp -R ~/Documents/demonlist-builder .claude/skills/demonlist-builder
```
Use a symlink to keep one source of truth; use copy to version it per project.

## Antigravity

Place it where Antigravity reads agent skills/workflows, e.g.:
```bash
mkdir -p ~/.antigravity-ide/skills
ln -s ~/Documents/demonlist-builder ~/.antigravity-ide/skills/demonlist-builder
```
Then reference SKILL.md from your agent config if the IDE asks for a path.

## Verify

- The agent should discover the skill by its name/description in SKILL.md.
- Trigger it with: "build me a demonlist" / "scaffold a GD list on <database>".

## Layout

```
demonlist-builder/
  SKILL.md
  INSTALL.md
  references/  archetypes, data-model, database-adapters,
               points-and-ranking, moderation, scaffolding
  scripts/     points_engine.py, schema/{postgres,sqlite}.sql
  templates/   demonlist.config.json, static-json/{_list.json,data/}
```
