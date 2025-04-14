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
---
## 📂 Estructura del proyecto

```plaintext
backend/
├── main.py                  # Punto de entrada de la aplicación FastAPI
├── routes/                  # Endpoints del sistema
│   ├── usuarios.py          # Rutas de autenticación, login, registro
│   ├── prendas.py           # Rutas CRUD para gestionar prendas
│   ├── outfits.py           # Rutas para crear y consultar outfits
│   └── analisis.py          # Ruta para análisis cromático (modelo IA)
├── models/                  # Modelos ORM SQLAlchemy para la base de datos
│   ├── usuario.py           # Modelo de Usuario
│   ├── prenda.py            # Modelo de Prenda
│   ├── outfit.py            # Modelos de Outfit, Detalle_Outfit y Recomendacion
│   └── estilo.py            # Modelo de Estilo_Prenda
├── schemas/                 # Validaciones de entrada/salida con Pydantic
│   ├── usuario.py           # Esquemas para creación y respuesta de usuario
│   ├── prenda.py            # Esquemas para operaciones con prendas
│   ├── outfit.py            # Esquemas para outfits y recomendaciones
│   └── analisis.py          # Esquema para análisis cromático
├── utils/                   # Funciones auxiliares
│   ├── s3_upload.py         # Subida de imágenes a Amazon S3
│   └── ia_predictor.py      # Carga y ejecución del modelo de IA (ResNet)
├── ml_models/               # Modelos entrenados para IA
│   └── skin_type_model_entero.pt  # Modelo de clasificación de tono de piel
├── requirements.txt         # Lista de dependencias del backend
├── .env.template            # Plantilla de archivo de configuración (.env)
└── README.md                # Documentación del backend
---
## 📂 Estructura del proyecto
