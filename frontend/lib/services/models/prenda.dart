// This file defines the Prenda class, which represents a clothing item with various attributes.
// It includes a constructor for initializing the object and a factory method for creating an instance from JSON data.
import 'dart:convert';
import 'package:http/http.dart' as http;
  

class Prenda {
  final int id;
  final String nombre;
  final String tipo;
  final String color;
  final String temporada;
  final String estadoUso;
  final String? imagenUrl;
  final int idUsuario;
  final int idEstilo;


  Prenda({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.color,
    required this.temporada,
    required this.estadoUso,
    required this.imagenUrl,
    required this.idUsuario,
    required this.idEstilo,
  
  });

  factory Prenda.fromJson(Map<String, dynamic> json) {
    return Prenda(
      id: json['id_prenda'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      color: json['color'],
      temporada: json['temporada'],
      estadoUso: json['estado_uso'],
      imagenUrl: json['imagen_url'],
      idUsuario: json['id_usuario'],
      idEstilo: json['id_estilo'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'color': color,
      'temporada': temporada,
      'estado_uso': estadoUso,
      'imagen_url': imagenUrl,
      'id_usuario': idUsuario,
      'id_estilo': idEstilo,
    };
  }
}

