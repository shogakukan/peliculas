# Cine y TV: Letterboxd circle packing

Visualiza los registros del Diary de Letterboxd agrupados por tag.

## Actualizar

1. Exportar desde Letterboxd (Settings → Import & Export → Export your data) y copiar `diary.csv` a la raíz del repo.
   El CSV no se versiona (`.gitignore`): solo se publica `docs/data.js`, que tiene totales por año y tag.
2. `python3 build.py` → regenera `docs/data.js` e imprime cuántos registros se ignoraron.
3. Abrir `docs/index.html` para revisar (funciona con doble clic, sin servidor).
4. `git add docs/data.js && git commit -m "Actualizar datos" && git push`

## Reglas

- Tags en minúscula y comparación exacta (`cinear` ≠ `cine`).
- Con tag `cine` → círculo **Cine**, subcírculo = el otro tag. Solo `cine` → se ignora.
- Sin `cine` → círculo **TV**, subcírculo = su tag.
- Sin tags → se ignora.
- Año = `Watched Date`. Cada registro cuenta 1.

## GitHub Pages

Settings → Pages → Deploy from a branch → `main` / `/docs`.
