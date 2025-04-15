# 👕 Outfit Recommender

Outfit Recommender es una aplicación móvil inteligente que recomienda atuendos personalizados en función del **tono de piel** del usuario, gestionando un closet virtual y proporcionando análisis de uso y estilo. Desarrollada con **Flutter (frontend)** y **FastAPI (backend)**, con integración de **modelo IA (ResNet34)** y servicios en la nube con **Amazon Web Services (S3 y RDS)**.

---

## 🚀 Funcionalidades principales

- 🛂 Registro e inicio de sesión de usuarios
- 📸 Análisis cromático con IA desde una imagen
- 👕 Closet virtual con gestión de prendas
- 🧠 Recomendación de outfits personalizados
- 📊 Métricas de uso e historial de atuendos
- ☁️ Subida y almacenamiento de imágenes en AWS S3

---

## 🏗️ Arquitectura del sistema

```plaintext
[Flutter App] <--> [FastAPI Backend] <--> [MySQL en RDS]
                    |
                    └--> [Modelo IA (ResNet34)]
                    |
                    └--> [Amazon S3 - Imagenes de usuarios y prendas]
```
---
## 📂 Estructura del proyecto
```plaintext
.
├── backend/              # Backend con FastAPI y modelo IA
│   └── README.md
├── frontend/             # Aplicación móvil Flutter
│   └── README.md
├── README.md             # Este archivo

```
---

## ▶️ Cómo ejecutar el proyecto
🔧 **Backend (FastAPI)**
```bash
cd backend/
pip install -r requirements.txt
uvicorn app.main:app --reload
```
Requiere archivo .env con:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - BUCKET_NAME
  - DATABASE_URL (MySQL)
---
## 📱 Frontend (Flutter)
```bash
cd frontend/
flutter pub get
flutter run
```
  - Edita el archivo lib/services/*.dart para apuntar al host local (ej: http://10.0.2.2:8000)
---
##  🧠 Inteligencia Artificial
- Modelo: ResNet34 entrenado en PyTorch
- Ubicación: backend/app/modelos/skin_type_model.pt
- Entrada: imagen facial
- Salida: tono de piel (Tipo I a Tipo VI)
- Uso: genera paleta de colores y recomendaciones de outfit
---

## ☁️ Tecnologías utilizadas
- Frontend: Flutter (Dart)
- Backend: FastAPI (Python)
- Base de Datos: MySQL (Amazon RDS)
- Almacenamiento: Amazon S3
- IA: PyTorch + ResNet34
- ORM: SQLAlchemy
- Validación: Pydantic
- API HTTP: http package (Flutter)
---
👨‍💻 Autor

Diego Andrés Reinoso Calderón

Universidad San Francisco de Quito

Tutor: Felipe Grijalva Arévalo
