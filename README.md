# Sitio personal — Franklin.jl

Reproducción de https://maurimendiluce.github.io/ usando [Franklin.jl](https://franklinjl.org/).

## Uso local

1. Instalá Julia (https://julialang.org/downloads/).
2. Desde este directorio, en la terminal de Julia:

```julia
using Pkg
Pkg.add("Franklin")
using Franklin
serve()  # levanta un servidor local con recarga automática
```

3. Abrí `http://localhost:8000` en el navegador.

## Estructura

- `config.md` — variables globales del sitio (título, autor, etc.)
- `index.md` — página principal (perfil, publicaciones, charlas, docencia)
- `optimizacion/index.md` — subpágina del curso de Optimización
- `_layout/` — plantillas HTML (head, foot, page_foot)
- `_css/basic.css` — estilos
- `.github/workflows/deploy.yml` — build y deploy automático a GitHub Pages (rama `gh-pages`)

## Deploy a GitHub Pages

1. Creá el repo `maurimendiluce.github.io` (o el que uses) y pusheá este contenido a `main`.
2. En GitHub → Settings → Pages, configurá "Deploy from a branch" → rama `gh-pages`, carpeta `/ (root)`.
3. Cada push a `main` dispara el workflow, que compila el sitio con Franklin y lo publica en `gh-pages`. Esto evita el proceso manual de copiar `__site/` que suele romperse.

## Pendiente / a personalizar

- Agregar tu foto en `assets/image.jpg` (referenciada en `index.md`).
- Agregar `assets/favicon.png`.
- Completar el contenido real de `optimizacion/index.md` (clases, prácticas, material).
- Ajustar `config.md` con la URL final del sitio.
