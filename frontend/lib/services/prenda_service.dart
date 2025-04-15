import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'models/prenda.dart';

class PrendaService {
  // Subir imagen
  static Future<String> uploadImage(File imageFile, int idUsuario) async {
    final uri = Uri.parse('http://10.0.2.2:8000/upload/image');
    var request = http.MultipartRequest('POST', uri);
    request.fields['id_usuario'] = idUsuario.toString();
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr)['url'];
    } else {
      throw Exception('Error al subir imagen');
    }
  }

  // Crear prenda
  static Future<void> crearPrenda({
    required String nombre,
    required String tipo,
    required String color,
    required String temporada,
    required String estadoUso,
    required int idUsuario,
    required String? imagenUrl,
    required int idEstilo,
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
      "id_estilo": idEstilo,
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

  // Obtener prendas
  static Future<List<Prenda>> obtenerPrendas() async {
    final url = Uri.parse('http://10.0.2.2:8000/prendas/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Prenda.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener prendas: ${response.body}');
    }
  }
}
