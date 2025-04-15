# 🧰 Utils - Funciones auxiliares

Esta carpeta contiene funciones utilitarias que apoyan el funcionamiento del backend, pero no forman parte directa de la lógica principal (CRUD, rutas o modelos). Aquí se encuentran herramientas reutilizables para tareas como la subida de imágenes, validación, conversión de archivos, etc.

---
## 🗂️ Archivos principales

| Archivo           | Funcionalidad                                                 |
|-------------------|----------------------------------------------------------------|
| `s3_upload.py`     | Subida de archivos (imágenes) a Amazon S3, uso generalizado   |

---
## 📤 Subida de imágenes - `s3_upload.py`

Este módulo proporciona una función para subir imágenes de usuario o prendas a un bucket de Amazon S3, generando automáticamente la URL pública que se usará para mostrar las imágenes en la aplicación móvil.

### Función principal
```python
def upload_image_to_s3(file, id_usuario: int, folder="outfits") -> str:
    """
    Sube una imagen al bucket de Amazon S3 y retorna su URL pública.

    Args:
        file: archivo (objeto tipo UploadFile de FastAPI)
        id_usuario: ID del usuario dueño de la imagen
        folder: subcarpeta destino ('outfits' o 'users')

    Returns:
        str: URL pública del archivo en S3
```
---
## ✅ Ejemplo de uso

```python
from app.utils.s3_upload import upload_image_to_s3

# Supongamos que se recibe un archivo en un endpoint
imagen_url = upload_image_to_s3(file, id_usuario=3, folder="users")
print(imagen_url)
# Salida esperada: https://outfit-ai-images.s3.us-east-2.amazonaws.com/users/user_3/nombre_archivo.jpg

```
---
## ☁️ Requisitos
Este módulo depende de:
- boto3 (cliente AWS)
- Variables de entorno .env:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `BUCKET_NAME`
---
## 🧠 Recomendaciones
- Usar carpetas por tipo (users, outfits, etc.) para organización
- Validar extensiones de archivo antes de subir
- Renombrar archivos con UUID para evitar colisiones
- Controlar permisos del bucket para asegurar acceso sólo a imágenes necesarias
---
Autor

Diego Andrés Reinoso Calderón

Proyecto: Outfit Recommender
