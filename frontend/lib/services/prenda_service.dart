import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'models/prenda.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

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
  static Future<int> crearPrenda({
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
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data["id_prenda"];
    } else {
    throw Exception("Error al guardar prenda: ${response.body}");
    }
  }
  // Obtener prendas
  static Future<void> actualizarPrenda(Prenda prenda) async {
  final url = Uri.parse('http://10.0.2.2:8000/prendas/${prenda.id}');
  final body = jsonEncode({
    "nombre": prenda.nombre,
    "tipo": prenda.tipo,
    "color": prenda.color,
    "temporada": prenda.temporada,
    "estado_uso": prenda.estadoUso,
    "imagen_url": prenda.imagenUrl,
    "id_usuario": prenda.idUsuario,
    "id_estilo": prenda.idEstilo,
  });

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode != 200) {
    throw Exception("Error al actualizar prenda: ${response.body}");
    }
  }
   static Future<List<Prenda>> obtenerPrendas() async {
    final idUsuario = SesionUsuario.idUsuario;
    final url = Uri.parse('http://10.0.2.2:8000/prendas/usuario/$idUsuario');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Prenda.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener prendas: ${response.body}');
    }
  }
  static Future<void> asociarOcasion(int prendaId, int ocasionId) async {
  final url = Uri.parse('http://10.0.2.2:8000/prendas/asociar_ocasion/?prenda_id=$prendaId&ocasion_id=$ocasionId');
  
  final response = await http.post(url); 

  if (response.statusCode != 201) {
    throw Exception('Error al asociar ocasión: ${response.body}');
  }
  }
  static Future<List<Prenda>> obtenerPrendasUsuario(int idUsuario) async {
  final url = Uri.parse('http://10.0.2.2:8000/usuario/$idUsuario');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Prenda.fromJson(item)).toList();
  } else {
    throw Exception('Error al obtener prendas del usuario: ${response.body}');
    }
  }

  static Future<void> cargarPrendasMasivasDesdeFile(List<File> imagenes, int idUsuario, String tipo) async {
  for (File imageFile in imagenes) {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/prendas/carga-masiva'),
    );

    request.fields['id_usuario'] = idUsuario.toString();
    request.fields['tipo'] = tipo;
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Error al subir ${imageFile.path}');
    }
  }
}
}