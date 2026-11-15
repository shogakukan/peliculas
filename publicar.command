#!/bin/sh
# Doble clic en Finder: toma el export de Letterboxd (zip) de esta carpeta, regenera
# docs/data.js, borra el zip y diary.csv, commitea la web y la sube a GitHub.
# También se puede correr desde la terminal: ./publicar.command ["mensaje opcional"]
#
# - Si hay varios zips de Letterboxd, usa el de fecha más reciente y borra todos.
# - Si no hay zip, no regenera datos y publica igual los cambios de la web.
# - Solo commitea docs/data.js y docs/index.html.
cd "$(dirname "$0")" || exit 1

WEB_FILES="docs/data.js docs/index.html"

# Zips de export: letterboxd-<usuario>-AAAA-MM-DD-HH-MM-utc.zip, ordenados por esa fecha.
ZIPS=$(ls letterboxd-*-utc.zip 2>/dev/null \
  | sed -E 's/^(.*-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2})-utc\.zip)$/\2 \1/' \
  | sort | cut -d' ' -f2-)

echo "== Generando datos"
if [ -z "$ZIPS" ]; then
  echo "No hay zip de Letterboxd en esta carpeta: se publica sin datos nuevos."
else
  ZIP=$(echo "$ZIPS" | tail -n 1)
  echo "Usando $ZIP"
  # Solo el diary.csv de la raíz del zip (no los de deleted/ ni orphaned/).
  unzip -p "$ZIP" diary.csv > diary.csv 2>/dev/null && [ -s diary.csv ] \
    || { rm -f diary.csv; echo "ERROR: $ZIP no tiene diary.csv. No se borró nada."; exit 1; }
  python3 build.py || { echo "ERROR: falló build.py. No se borró nada."; exit 1; }

  echo "$ZIPS" | while IFS= read -r z; do rm -f "$z"; echo "Borrado: $z"; done
  rm -f diary.csv
  echo "Borrado: diary.csv"
fi

echo
echo "== Commit"
# shellcheck disable=SC2086
if git diff --quiet HEAD -- $WEB_FILES; then
  echo "Nada nuevo para commitear."
else
  if git diff --quiet HEAD -- docs/data.js; then
    DEFAULT_MSG="Actualizar página ($(date +%Y-%m-%d))"
  else
    DEFAULT_MSG="Actualizar datos ($(date +%Y-%m-%d))"
  fi
  # shellcheck disable=SC2086
  git commit -q -m "${1:-$DEFAULT_MSG}" -- $WEB_FILES || { echo "ERROR: falló el commit"; exit 1; }
  git log -1 --format='%h %s'
fi

echo
echo "== Subiendo a GitHub"
git push -q || { echo "ERROR: falló el push"; exit 1; }
echo "Listo. GitHub Pages tarda ~1 minuto en actualizarse."
