# Cine y TV: Letterboxd circle packing

Visualiza los registros del Diary de Letterboxd agrupados por tag.

## Actualizar

1. Exportar desde Letterboxd (Settings → Import & Export → Export your data) y dejar el zip
   (`letterboxd-<usuario>-<fecha>-utc.zip`) en la raíz de este repositorio.
2. Doble clic en `publicar.command`. El script:
   - toma el `diary.csv` principal del zip (si hay varios zips, usa el más nuevo),
   - regenera `docs/data.js` con `build.py`,
   - borra todos los zips de Letterboxd y `diary.csv`,
   - commitea solo `docs/data.js` y `docs/index.html`, y hace push.

   Si no hay zip, no regenera datos y publica igual los cambios de la página.
   Desde la terminal acepta un mensaje de commit opcional: `./publicar.command "Corrijo tags de 2019"`.

Ni el zip ni `diary.csv` se suben a GitHub (`.gitignore`): solo `docs/data.js`, que tiene totales por año y tag.

## Reglas

- Tags en minúscula y comparación exacta (`cinear` ≠ `cine`).
- Con tag `cine` → círculo **Cine**, subcírculo = el otro tag. Solo `cine` → se ignora.
- Sin `cine` → círculo **TV**, subcírculo = su tag.
- Sin tags → se ignora.
- Año = `Watched Date`. Cada registro cuenta 1.

## GitHub Pages

Settings → Pages → Deploy from a branch → `main` / `/docs`.
