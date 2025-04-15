import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class OutfitService {
  static const String baseUrl = "http://10.0.2.2:8000";

  /// Crear un nuevo outfit con sus prendas y recomendación asociada
  static Future<void> registrarOutfit({
    required String nombre,
    required int idOcasion,
    required List<int> idsPrendas,
  }) async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) throw Exception("Usuario no logueado");

    // 1. Crear outfit
    final response = await http.post(
      Uri.parse('$baseUrl/outfits/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "nombre": nombre,
        "id_ocasion": idOcasion
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear el outfit: ${response.body}");
    }

    final outfitId = jsonDecode(response.body)['id_outfit'];

    // 2. Crear detalles del outfit
    for (int idPrenda in idsPrendas) {
      final detalleResponse = await http.post(
        Uri.parse('$baseUrl/detalles-outfit/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_outfit": outfitId,
          "id_prenda": idPrenda,
        }),
      );

      if (detalleResponse.statusCode != 201) {
        throw Exception("Error al agregar prenda al outfit: ${detalleResponse.body}");
      }
    }

    // 3. Crear recomendación
    final recomendacionResponse = await http.post(
      Uri.parse('$baseUrl/recomendaciones/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "id_outfit": outfitId,
        "feedback_usuario": "aceptado", // o pendiente, dependiendo de lógica
      }),
    );

    if (recomendacionResponse.statusCode != 201) {
      throw Exception("Error al guardar la recomendación: ${recomendacionResponse.body}");
    }
  }

  /// Obtener outfit recomendado (futuro, IA o aleatorio)
  static Future<Map<String, dynamic>> obtenerOutfitRecomendado() async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) throw Exception("Usuario no logueado");

    final response = await http.get(
      Uri.parse('$baseUrl/recomendaciones/usuario/$idUsuario'),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al obtener outfit recomendado: ${response.body}");
    }

    return jsonDecode(response.body);
  }
  /// Generar un nuevo outfit aleatorio (simulado o por IA)
  static Future<Map<String, dynamic>> generarOutfitAleatorio(int idUsuario) async {
    final response = await http.get(
    Uri.parse('$baseUrl/outfits/generar/$idUsuario'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Devuelve el JSON completo
  } else {
    throw Exception("Error al generar outfit: ${response.body}");
  }
  }


  /// Aceptar y guardar outfit generado
  static Future<void> aceptarOutfitGenerado(int idUsuario) async {
    final response = await http.post(
    Uri.parse('$baseUrl/outfits/aceptar/$idUsuario'),
  );

  if (response.statusCode != 201) {
    throw Exception("Error al guardar outfit generado: ${response.body}");
    }
  }

}
