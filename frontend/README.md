# 👗 Outfit Recommender - Frontend (Flutter)

Este módulo representa la aplicación móvil del proyecto **Outfit Recommender**, desarrollada en **Flutter**. Permite a los usuarios gestionar su closet virtual, realizar análisis cromático con inteligencia artificial, visualizar recomendaciones de atuendos y guardar su historial de uso.

---

## 📱 Funcionalidades principales

- 🛂 Registro e inicio de sesión
- 📸 Subida de imágenes para análisis cromático
- 👕 Gestión del closet virtual
- 🤖 Recomendación automática de outfits
- 📊 Visualización de métricas de uso
- ⚙️ Pantalla de configuración del usuario

---

## ⚙️ Requisitos

- Flutter SDK ≥ 3.x
- Android Studio o Visual Studio Code
- Conexión con el backend FastAPI en ejecución
- Configuración en `lib/services/` para apuntar al backend local o en la nube

---

## 📂 Estructura de carpetas

```plaintext
frontend/
├── android/                # Configuración para Android
├── assets/                 # Imágenes, íconos y archivos estáticos
├── ios/ / linux/ / macos/  # Configuraciones multiplataforma
├── lib/
│   ├── screens/            # Todas las pantallas principales de la app
│   │   ├── inicio_aplicacion.dart
│   │   ├── inicio_sesion_widget.dart
│   │   ├── crear_cuenta.dart
│   │   ├── home.dart
│   │   ├── home_content.dart
│   │   ├── closetvirtual_widget.dart
│   │   ├── recomendaciones_widget.dart
│   │   ├── analisi_cromatico.dart
│   │   ├── configuraciones_widget.dart
│   │   └── NuevaPrendaWidget.dart
│   ├── services/           # Comunicación con backend (API REST)
│   │   ├── auth_service.dart
│   │   ├── usuario_service.dart
│   │   ├── outfit_service.dart
│   │   └── prenda_service.dart
│   ├── models/             # (opcional) Modelos de datos si aplican
│   └── main.dart           # Punto de entrada de la app
├── pubspec.yaml            # Configuraciones del proyecto y dependencias
└── README.md               # Documentación del frontend
```
---
## ▶️ Cómo ejecutar la app

# 1. Asegúrate de tener Flutter instalado
flutter pub get        # Instala las dependencias
flutter run            # Ejecuta la app en tu emulador o dispositivo

---
## 🧩 Ejemplo de flujo
1. El usuario se registra o inicia sesión (auth_service.dart)
2. Sube una imagen y realiza análisis cromático (usuario_service.dart)
3. Visualiza su closet virtual (closetvirtual_widget.dart)
4. Genera una recomendación y acepta el outfit (outfit_service.dart)
5. Todo se comunica con el backend en tiempo real

---
## 🔗 Comunicación con el backend
Asegúrate de que los services/*.dart estén apuntando al backend FastAPI:

```dart
const String baseUrl = 'http://10.0.2.2:8000'; // o IP pública si está en nube

```  
---
Autor

👨‍💻 Autor
Diego Andrés Reinoso Calderón

Ingeniería en Ciencias de la Computación

Universidad San Francisco de Quito

Tutor: Felipe Grijalva Arévalo


