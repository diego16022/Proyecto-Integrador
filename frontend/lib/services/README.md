# 🔌 Servicios API - Outfit Recommender

Esta carpeta contiene los servicios que permiten a la app Flutter comunicarse con el backend desarrollado en FastAPI. Cada archivo maneja las peticiones HTTP (GET, POST, etc.) para una entidad o módulo específico del sistema.

---

## 🗂️ Archivos y funcionalidad

| Archivo                | Descripción                                                 |
|------------------------|-------------------------------------------------------------|
| `auth_service.dart`     | Registro, login y autenticación de usuarios (JWT)          |
| `usuario_service.dart`  | Subida de imagen, análisis cromático y actualización de perfil |
| `prenda_service.dart`   | Gestión de prendas: crear, listar, eliminar, asociar estilo |
| `outfit_service.dart`   | Generación, consulta y aceptación de outfits               |

---

## 🧩 Estructura típica de un servicio

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> login(String correo, String contrasena) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios/login'),
      body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }
}
```
---
## 🔁 Flujo típico

1. Usuario interactúa con una pantalla (Widget)
2. El Widget llama a un método del servicio (AuthService.login, OutfitService.getOutfits)
3. El servicio realiza una petición al backend
4. Se recibe la respuesta, se transforma con jsonDecode, y se retorna a la UI

---
## ✅ Buenas prácticas

- Define _baseUrl de forma centralizada para facilitar cambios
- Usa clases estáticas si no necesitas estado (como lo estás haciendo)
- Agrega headers correctamente: Content-Type: application/json, Authorization: Bearer ...
- Maneja errores (statusCode != 200) y lanza excepciones claras
- Usa try-catch en los Widgets al llamar los servicios

---
## 🔐 Seguridad

- Almacena el token JWT usando flutter_secure_storage
- Usa el token en cada petición autenticada:
```dart
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
}
```
---
## 🧪 Posibles mejoras futuras

- Implementar interceptors si usas una librería como dio
- Separar modelos (models/usuario.dart, prenda.dart) para parsear automáticamente
- Implementar pruebas unitarias de servicios con mockito o http_mock_adapter

---
Autor

Diego Andrés Reinoso Calderón

Proyecto: Outfit Recommender
