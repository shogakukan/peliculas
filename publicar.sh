#!/bin/sh
# Regenera docs/data.js desde diary.csv, commitea y sube a GitHub.
# Uso: ./publicar.sh ["mensaje opcional"]
set -e
cd "$(dirname "$0")"

python3 build.py

git add -A
if git diff --cached --quiet; then
  echo "Nada nuevo para commitear."
else
  git commit -q -m "${1:-Actualizar datos ($(date +%Y-%m-%d))}"
  echo "Commit: $(git log -1 --format='%h %s')"
fi

git push -q
echo "Publicado en GitHub. Pages tarda ~1 minuto en actualizarse."
