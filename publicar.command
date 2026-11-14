#!/bin/sh
# Doble clic en Finder: regenera docs/data.js desde diary.csv, commitea y sube a GitHub.
# También se puede correr desde la terminal: ./publicar.command ["mensaje opcional"]
cd "$(dirname "$0")" || exit 1

fin() {
  echo
  printf "Presioná Enter para cerrar..."
  read -r _
  exit "$1"
}

echo "== Generando datos"
python3 build.py || { echo "ERROR: falló build.py (¿está diary.csv en la carpeta?)"; fin 1; }

echo
echo "== Commit"
git add -A
if git diff --cached --quiet; then
  echo "Nada nuevo para commitear."
else
  git commit -q -m "${1:-Actualizar datos ($(date +%Y-%m-%d))}" || { echo "ERROR: falló el commit"; fin 1; }
  echo "$(git log -1 --format='%h %s')"
fi

echo
echo "== Subiendo a GitHub"
git push -q || { echo "ERROR: falló el push"; fin 1; }
echo "Listo. GitHub Pages tarda ~1 minuto en actualizarse."
fin 0
