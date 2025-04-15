# 📦 Esquemas (Schemas) - Pydantic
Esta carpeta contiene todos los esquemas de datos utilizados por FastAPI para:

- Validar entradas (`request`)
- Formatear salidas (`response`)
- Establecer reglas de serialización

Todos los esquemas están construidos con **Pydantic** y definen la forma en que se estructuran los datos que se envían o reciben desde los endpoints ubicados en `routers/`.

---
## 🗂️ Archivos disponibles

| Archivo                | Funcionalidad principal                                 |
|------------------------|----------------------------------------------------------|
| `usuario.py`           | Esquemas para crear, autenticar y mostrar usuarios      |
| `prenda.py`            | Esquemas de prendas (crear, listar, actualizar)         |
| `outfit.py`            | Esquemas de outfits y detalles relacionados             |
| `recomendaciones.py`   | Estructura de datos para sugerencias de atuendos        |
| `estilo.py`            | Esquemas de estilos de prenda                           |
| `ocasion.py`           | Esquemas relacionados con tipos de ocasión              |
| `historial_uso.py`     | Definición del historial de uso de prendas u outfits    |
| `metrica_uso.py`       | Métricas de uso como frecuencia o rotación              |
| `detalle_outfit.py`    | Asociaciones entre outfits y prendas                    |
| `prenda_ocasion.py`    | Vinculación entre prendas y ocasiones específicas        |

---
## 🧱 Ejemplo básico
Archivo: `usuario.py`

```python
from pydantic import BaseModel, EmailStr

class UsuarioBase(BaseModel):
    nombre: str
    correo: EmailStr

class UsuarioCreate(UsuarioBase):
    contrasena: str

class UsuarioOut(UsuarioBase):
    id: int
    tono_piel: str
    class Config:
        orm_mode = True
```
---
## 🔁 Ciclo típico en FastAPI
  1. Se recibe una petición con datos JSON.
  2. FastAPI convierte esos datos en un objeto **Pydantic**.
  3. Se ejecuta la lógica de negocio (por ejemplo, dentro del archivo `crud/`).
  4. Se retorna un objeto validado por un **schema de salida**.
---
## 📤 Ejemplo de uso
Entrada (request body):

```JSON
{
  "nombre": "Diego",
  "correo": "diego@email.com",
  "contrasena": "123456"
}
```
Respuesta esperada:
```JSON
{
  "id": 1,
  "nombre": "Diego",
  "correo": "diego@email.com",
  "tono_piel": "Tipo IV"
}
```
---
Autor

Diego Andrés Reinoso Calderón

Proyecto: Outfit Recommender


