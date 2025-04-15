# 🖼️ Pantallas (Screens) - Outfit Recommender

Esta carpeta contiene las diferentes pantallas que componen la interfaz gráfica de la app **Outfit Recommender**. Cada archivo `.dart` aquí representa una vista interactiva con la que el usuario puede interactuar.

---
## 🗂️ Archivos y funcionalidad

| Archivo                      | Descripción de la pantalla                              |
|-----------------------------|----------------------------------------------------------|
| `inicio_aplicacion.dart`    | Pantalla de splash/inicio al abrir la app               |
| `inicio_sesion_widget.dart` | Pantalla de inicio de sesión                             |
| `crear_cuenta.dart`         | Registro de nuevos usuarios                              |
| `home.dart`                 | Estructura del home con navegación inferior              |
| `home_content.dart`         | Contenido principal mostrado en el home                 |
| `closetvirtual_widget.dart` | Visualización de las prendas del usuario                 |
| `recomendaciones_widget.dart`| Recomendaciones generadas automáticamente               |
| `analisi_cromatico.dart`    | Subida de foto y análisis de tono de piel               |
| `configuraciones_widget.dart`| Configuración de perfil, idioma, notificaciones         |
| `NuevaPrendaWidget.dart`    | Formulario para añadir una nueva prenda al closet        |

---
## 🔁 Flujo de navegación típico

```plaintext
inicio_aplicacion.dart
   ↓
inicio_sesion_widget.dart / crear_cuenta.dart
   ↓
home.dart (barra de navegación inferior)
   ├── home_content.dart
   ├── closetvirtual_widget.dart
   ├── analisi_cromatico.dart
   ├── recomendaciones_widget.dart
   └── configuraciones_widget.dart
```
---
## 🧩 Ejemplo de navegación
Desde home.dart, puedes navegar a otra pantalla con:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NuevaPrendaWidget()),
);
```
---
## 🎯 Buenas prácticas
- Separa cada pantalla en su propio archivo .dart como ya lo estás haciendo.
- Utiliza StatelessWidget o StatefulWidget dependiendo de si necesita estado.
- Mantén la lógica de negocio (como peticiones HTTP) fuera de estas pantallas (en services/).
- Si usas imágenes o íconos, gestiona todo dentro de la carpeta assets/.
---
## 🧪 Siguiente mejora posible
- Añadir carpetas internas como widgets/ para subcomponentes reutilizables
- Integrar controladores (ej. con provider, bloc, etc.) si planeas escalar
---
Autor

Diego Andrés Reinoso Calderón

Proyecto: Outfit Recommender
