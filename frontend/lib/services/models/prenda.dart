// This file defines the Prenda class, which represents a clothing item with various attributes.
// It includes a constructor for initializing the object and a factory method for creating an instance from JSON data.
import 'dart:convert';
import 'package:http/http.dart' as http;
  

class Prenda {
  final int idPrenda;
  final String nombre;
  final String tipo;
  final String color;
  final String temporada;
  final String estadoUso;
  final String? imagenUrl;
  final DateTime? fechaRegistro;

  Prenda({
    required this.idPrenda,
    required this.nombre,
    required this.tipo,
    required this.color,
    required this.temporada,
    required this.estadoUso,
    this.imagenUrl,
    this.fechaRegistro,
  });

  factory Prenda.fromJson(Map<String, dynamic> json) {
    return Prenda(
      idPrenda: json['id_prenda'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      color: json['color'],
      temporada: json['temporada'],
      estadoUso: json['estado_uso'],
      imagenUrl: json['imagen_url'],
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'])
          : null,
    );
  }
}
