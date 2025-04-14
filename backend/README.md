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

## 📂 Estructura del backend

backend/ ├── main.py # Inicializa FastAPI y monta las rutas ├── routes/ # Endpoints: usuarios, prendas, outfits, análisis ├── models/ # Modelos SQLAlchemy (Usuario, Prenda, Outfit, etc.) ├── schemas/ # Pydantic para validaciones de entrada/salida ├── utils/ │ ├── s3_upload.py # Función para subir imágenes a Amazon S3 │ └── ia_predictor.py # Carga el modelo y predice el tono de piel ├── ml_models/ │ └── skin_type_model_entero.pt # Modelo entrenado en PyTorch ├── requirements.txt # Dependencias └── .env.template # Variables de entorno necesarias


---

## 🔐 Variables de entorno (.env)

Asegúrate de tener un archivo `.env` con las siguientes claves:

```env
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
BUCKET_NAME=....
DATABASE_URL=mysql+mysqlconnector://usuario:password@host/db

---
## Cómo ejecutar el backend
# 1. Instalar dependencias
pip install -r requirements.txt

# 2. Ejecutar servidor en desarrollo
uvicorn main:app --reload
---
##📡 Endpoints principales
Método	Ruta	Funcionalidad
POST	/usuarios/	Crear nuevo usuario
POST	/usuarios/login	Iniciar sesión
POST	/usuarios/{id}/analisis-cromatico	Subir imagen, predecir tono de piel, guardar resultado
POST	/upload/prenda	Subir imagen de prenda a S3 y retornar URL
POST	/prendas/	Crear prenda vinculada a un usuario
GET	/prendas/{id_usuario}	Listar todas las prendas de un usuario
GET	/colores-recomendados/{tono_piel}	Obtener paleta de colores recomendada según tono de piel
POST	/outfits/	Crear outfit aceptado desde sugerencia
GET	/outfits/{id_usuario}	Listar historial de outfits del usuario
---
🧠 Modelo de IA
Modelo: ResNet34 entrenado con PyTorch

Tarea: Clasificación de tono de piel (6 clases)

Entrada: Imagen subida por el usuario

Salida: Clase de tono de piel (ej. "Tipo IV") → usada para paleta recomendada
---
☁️ Integraciones AWS
Amazon S3: almacenamiento de imágenes en carpetas:

users/user_{id} → imagen del análisis cromático

outfits/user_{id} → imágenes de prendas

Amazon RDS: base de datos MySQL con tablas:

Usuario, Prenda, Outfit, Detalle_Outfit, Recomendacion, etc.
---
👨‍💻 Autor
Diego Andrés Reinoso Calderón
Universidad San Francisco de Quito
Tutor: Felipe Grijalva Arévalo
