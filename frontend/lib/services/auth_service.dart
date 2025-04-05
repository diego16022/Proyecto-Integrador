import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String contrasena) async {
    final url = Uri.parse('http://10.0.2.2:8000/usuarios/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        'contrasena': contrasena,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Correo o contraseña incorrectos");
    }
  }
  static Future<Map<String, dynamic>> registrarUsuario(
    String nombre, String email, String contrasena) async {
    final url = Uri.parse('http://10.0.2.2:8000/usuarios/');

    final body = jsonEncode({
      "nombre": nombre,
      "email": email,
      "contrasena": contrasena,
      // No enviar "tono_piel" hasta que realmente lo tengas como string
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al registrar usuario: ${response.body}");
    }
  }
}
class PrendaService {
  static Future<void> crearPrenda({
    required String nombre,
    required String tipo,
    required String color,
    required String temporada,
    required String estadoUso,
    required int idUsuario,
    String? imagenUrl,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/prendas/');

    final body = jsonEncode({
      "nombre": nombre,
      "tipo": tipo,
      "color": color,
      "temporada": temporada,
      "estado_uso": estadoUso,
      "imagen_url": imagenUrl,
      "id_usuario": idUsuario,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 201) {
      throw Exception("Error al guardar prenda: ${response.body}");
    }
  }
}
