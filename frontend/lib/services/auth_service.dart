import 'package:http/http.dart' as http;
import 'dart:convert';

class SesionUsuario {
  static int? idUsuario;
  static String? nombre;
  static String? email;
}

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
      final data = jsonDecode(response.body);

      // Guardar sesión
      SesionUsuario.idUsuario = data['usuario_id'];
      SesionUsuario.nombre = data['nombre'];
      SesionUsuario.email = data['email'];
      print('Sesión iniciada: ID=${SesionUsuario.idUsuario}, nombre=${SesionUsuario.nombre}');

      print("Respuesta del backend: $data");



      return data;
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
