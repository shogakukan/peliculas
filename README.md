# Cine y TV: Letterboxd circle packing

Visualiza los registros del Diary de Letterboxd agrupados por tag.

## Actualizar

1. Exportar desde Letterboxd (Settings → Import & Export → Export your data) y copiar `diary.csv` a la raíz del repo.
   El CSV no se versiona (`.gitignore`): solo se publica `docs/data.js`, que tiene totales por año y tag.
2. `./publicar.sh` → regenera `docs/data.js`, commitea y hace push, todo de una.
   Acepta un mensaje de commit opcional: `./publicar.sh "Corrijo tags de 2019"`.

Para revisar antes de publicar: `python3 build.py` y abrir `docs/index.html` (funciona con doble clic).
`build.py` solo reescribe `data.js` si cambiaron los datos.

## Reglas

- Tags en minúscula y comparación exacta (`cinear` ≠ `cine`).
- Con tag `cine` → círculo **Cine**, subcírculo = el otro tag. Solo `cine` → se ignora.
- Sin `cine` → círculo **TV**, subcírculo = su tag.
- Sin tags → se ignora.
- Año = `Watched Date`. Cada registro cuenta 1.

## GitHub Pages

Settings → Pages → Deploy from a branch → `main` / `/docs`.
