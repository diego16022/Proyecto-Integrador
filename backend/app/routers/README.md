# 🌐 Rutas (Routers) - API REST

Esta carpeta contiene todos los **endpoints** del sistema agrupados por funcionalidad. Cada archivo define un conjunto de rutas específicas que se conectan con la lógica `CRUD`, validaciones con `schemas`, y respuestas gestionadas por `FastAPI`.

---

## 🗂️ Estructura de archivos

| Archivo                | Descripción de funcionalidad                            |
|------------------------|----------------------------------------------------------|
| `usuario.py`           | Registro, login, análisis cromático                     |
| `prenda.py`            | Crear, listar, eliminar prendas                         |
| `outfit.py`            | Generación y consulta de outfits                        |
| `upload.py`            | Subida de imágenes a Amazon S3                          |
| `recomendaciones.py`   | Recomendaciones de atuendos y colores                  |
| `prediccion.py`        | Endpoint para predecir tono de piel con IA             |
| `detalle_outfit.py`    | Rutas relacionadas al detalle de cada outfit           |
| `historial_uso.py`     | Historial de uso de prendas u outfits                  |
| `metrica_uso.py`       | Métricas de uso (uso frecuente, rotación, etc.)        |
| `ocasion.py`           | Rutas para tipos de ocasiones                          |
| `estilo.py`            | Estilos disponibles para cada prenda                   |
| `prenda_ocasion.py`    | Asociación entre prendas y ocasiones                   |

---

## 🧩 Ejemplo de uso básico

```python
# app/main.py
from fastapi import FastAPI
from app.routers import usuario, prenda, outfit

app = FastAPI()

app.include_router(usuario.router, prefix="/usuarios", tags=["Usuarios"])
app.include_router(prenda.router, prefix="/prendas", tags=["Prendas"])
app.include_router(outfit.router, prefix="/outfits", tags=["Outfits"])


##📤 Ejemplo de endpoint


