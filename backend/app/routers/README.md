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
```

---
## 📤 Ejemplo de endpoint
**Ruta**: POST /usuarios/login
```python
@router.post("/login")
def login_usuario(usuario: UsuarioLogin, db: Session = Depends(get_db)):
    db_usuario = verificar_credenciales(db, usuario)
    if not db_usuario:
        raise HTTPException(status_code=401, detail="Credenciales inválidas")
    return generar_token(db_usuario)
```
**Request JSON:**
```JSON
{
  "correo": "diego@email.com",
  "contrasena": "123456"
}
```
**Response JSON:**
```JSON
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5...",
  "token_type": "bearer"
}
```
---
## 🧠 Recomendaciones
- `Se recomienda mantener una única responsabilidad por archivo.`
- `Usar tags=["NombreGrupo"] para categorizar endpoints en Swagger.`
- `Separar la lógica de negocio en crud/ y usar solo controladores aquí.`
- `Utilizar dependencias como Depends(get_db) o Depends(get_current_user) para manejo de sesión y seguridad.`
---
Autor

Diego Andrés Reinoso Calderón

