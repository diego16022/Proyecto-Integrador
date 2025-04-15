import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;


class UsuarioServices {
  static Future<Map<String, dynamic>> realizarAnalisisCromatico(
    File imageFile, int idUsuario) async {
  final uri = Uri.parse('http://10.0.2.2:8000/usuarios/$idUsuario/analisis-cromatico');
  var request = http.MultipartRequest('POST', uri);
  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr); // contiene tono_piel y foto_url
  } else {
    throw Exception('Error al realizar análisis cromático');
  }
  }
  static Future<void> actualizarUsuario({
  required int idUsuario,
  required String nombre,
  required String email,
  required String contrasena,
  }) async {
  final url = Uri.parse('http://10.0.2.2:8000/usuarios/$idUsuario');

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "nombre": nombre,
      "email": email,
      "contrasena": contrasena,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al actualizar usuario: ${response.body}");
  }
  }
}
