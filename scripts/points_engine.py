"""Database-agnostic points + leaderboard engine.

Reads demonlist.config.json and a list of levels/records (plain dicts, from any
adapter) and returns player points + ranked leaderboard. See
references/points-and-ranking.md.
"""
import json
import math
from collections import defaultdict


def load_config(path):
    with open(path) as f:
        return json.load(f)


def points_for_position(pos, curve):
    if curve.get("type") == "exp":
        val = curve["max"] * math.exp(-curve["k"] * (pos - 1))
        return max(val, curve.get("floor", 0))
    # linear fallback
    return max(curve["max"] - curve.get("step", 1) * (pos - 1),
              curve.get("floor", 0))


def partial_scale(progress, requirement, scale):
    if scale.get("type") == "linear":
        span = 100 - requirement
        return 0.0 if span <= 0 else (progress - requirement) / span
    return 1.0


def record_points(level, record, cfg):
    sc = cfg["scoring"]
    base = points_for_position(level["position"], sc["curve"])
    base *= sc.get("divisionMultipliers", {}).get(level["list_division"], 1.0)
    if record["progress"] >= 100:
        return base
    pc = sc.get("partialCredit", {})
    if not pc.get("enabled") or level["list_division"] not in pc.get(
            "appliesTo", []):
        return 0.0
    return base * partial_scale(record["progress"], level["requirement"],
                               pc["scale"])


def leaderboard(levels, records, cfg):
    by_id = {lv["id"]: lv for lv in levels}
    best = {}  # (player, level) -> points (keep max)
    for r in records:
        if r["status"] != "approved":
            continue
        lv = by_id.get(r["level_id"])
        if not lv or r["progress"] < lv["requirement"]:
            continue
        pts = record_points(lv, r, cfg)
        key = (r["player_id"], r["level_id"])
        best[key] = max(best.get(key, 0.0), pts)
    totals = defaultdict(float)
    for (player_id, _), pts in best.items():
        totals[player_id] += pts
    board = sorted(totals.items(), key=lambda kv: kv[1], reverse=True)
    out, rank, prev = [], 0, None
    for i, (player_id, total) in enumerate(board, start=1):
        if total != prev:
            rank, prev = i, total
        out.append({"player_id": player_id, "points": round(total, 2),
                    "rank": rank})
    return out


if __name__ == "__main__":
    import sys
    cfg = load_config(sys.argv[1])
    with open(sys.argv[2]) as f:
        data = json.load(f)
    print(json.dumps(
        leaderboard(data["levels"], data["records"], cfg), indent=2))
