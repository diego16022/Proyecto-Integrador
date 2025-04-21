import 'package:flutter/material.dart';

class RecomendacionCache {
  static String imagenOutfit = "";
  static String tonoPiel = "";
  static List<Color> colores = [];
  static List<String> imagenesPrendas = [];

  static void limpiar() {
    imagenOutfit = "";
    tonoPiel = "";
    colores = [];
    imagenesPrendas = [];
  }

  static bool hayRecomendacion() => imagenOutfit.isNotEmpty;
}