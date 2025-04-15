# 🧠 Backend - Outfit Recommender

Este módulo contiene el backend de la aplicación móvil **Outfit Recommender**, desarrollado con **FastAPI**. Su función principal es conectar la app móvil con la lógica de negocio, el modelo de IA para análisis cromático, la base de datos MySQL en AWS y el almacenamiento en Amazon S3.

---

## ⚙️ Funcionalidades implementadas

- 🔐 Autenticación segura de usuarios con JWT
- 👕 Gestión de prendas (crear, listar, eliminar)
- 🌈 Análisis cromático: predicción del tono de piel con modelo ResNet34
- 📸 Subida de imágenes (prendas y perfil) a Amazon S3
- 🎨 Recomendación de paletas de colores según el tono de piel detectado
- 👗 Generación y almacenamiento de outfits personalizados
- 📊 Consulta de historial de outfits y colores más usados

---

## 📂 Estructura del proyecto

```plaintext
backend/
├── app/
│   ├── main.py                  # Punto de entrada del backend
│   ├── database.py              # Configuración de conexión a MySQL (RDS)
│   ├── models.py                # Modelos generales opcionales
│   ├── crud/                    # Lógica CRUD desacoplada por entidad
│   │   ├── crud_usuario.py
│   │   ├── crud_prenda.py
│   │   ├── crud_outfit.py
│   │   ├── crud_estilo.py
│   │   ├── crud_ocasion.py
│   │   ├── crud_historial_uso.py
│   │   ├── crud_metrica_uso.py
│   │   └── ...
│   ├── modelos/                 # IA y recursos relacionados con el modelo de predicción
│   │   ├── descarga.py
│   │   ├── modelo_skin.py
│   │   └── skin_type_model.pt
│   ├── routers/                 # Rutas REST de la aplicación
│   │   ├── usuario.py
│   │   ├── prenda.py
│   │   ├── outfit.py
│   │   ├── upload.py
│   │   ├── prediccion.py
│   │   ├── recomendaciones.py
│   │   └── ...
│   ├── schemas/                 # Esquemas Pydantic para validación
│   │   ├── usuario.py
│   │   ├── prenda.py
│   │   ├── outfit.py
│   │   └── ...
│   └── utils/
│       └── s3_upload.py         # Función auxiliar para subir imágenes a S3
├── venv/                        # Entorno virtual (no se sube al repo)
└── README.md              
```
---
## 🔐 Variables de entorno `.env`
Crea un archivo .env con las siguientes variables:
AWS_ACCESS_KEY_ID=TU_CLAVE
AWS_SECRET_ACCESS_KEY=TU_SECRETO
BUCKET_NAME=outf

---
## ▶️ Cómo ejecutar el backend
 Instalar dependencias
pip install -r requirements.txt

Ejecutar servidor en desarrollo
uvicorn app.main:app --reload

---
