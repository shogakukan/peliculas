#!/usr/bin/env python3
"""Genera docs/data.js a partir del export de Diary de Letterboxd.

Uso:  python3 build.py [ruta/al/diary.csv]

Reglas:
  - Tags en minúscula, comparación exacta ("cinear" NO es "cine").
  - Con tag "cine": va a Cine, el subcírculo es el otro tag.
    Si solo tiene "cine", se ignora.
  - Sin tag "cine": va a TV, el subcírculo es su tag.
  - Sin tags: se ignora.
  - El año sale de "Watched Date". Cada registro cuenta 1.
"""
import csv
import json
import sys
from collections import defaultdict
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "diary.csv"
OUT = ROOT / "docs" / "data.js"


def main():
    # years[year][group][tag] = count
    years = defaultdict(lambda: {"cine": defaultdict(int), "tv": defaultdict(int)})
    skipped = defaultdict(int)

    with SRC.open(encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            year = (row.get("Watched Date") or "").strip()[:4]
            if not year.isdigit():
                skipped["sin watched date"] += 1
                continue
            tags = [t.strip().lower() for t in (row.get("Tags") or "").split(",")]
            tags = [t for t in tags if t]
            if not tags:
                skipped["sin tags"] += 1
                continue
            if "cine" in tags:
                rest = [t for t in tags if t != "cine"]
                if not rest:
                    skipped["solo cine"] += 1
                    continue
                years[year]["cine"][rest[0]] += 1
            else:
                years[year]["tv"][tags[0]] += 1

    data = {
        "generated": datetime.now().isoformat(timespec="seconds"),
        "years": {
            y: {g: dict(sorted(c.items())) for g, c in years[y].items()}
            for y in sorted(years)
        },
    }
    OUT.parent.mkdir(exist_ok=True)
    OUT.write_text(
        "window.DIARY = " + json.dumps(data, ensure_ascii=False, indent=1) + ";\n",
        encoding="utf-8",
    )

    total = sum(sum(c.values()) for y in years.values() for c in y.values())
    print(f"OK: {total} registros en {len(years)} años -> {OUT.relative_to(ROOT)}")
    for reason, n in skipped.items():
        print(f"  ignorados ({reason}): {n}")


if __name__ == "__main__":
    main()
