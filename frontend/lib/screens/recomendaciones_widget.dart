import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/outfit_service.dart';
import '../services/auth_service.dart';
import '../services/models/recomendacion_cache.dart';

class RecomendacionesWidget extends StatefulWidget {
  @override
  _RecomendacionesWidgetState createState() => _RecomendacionesWidgetState();
}

class _RecomendacionesWidgetState extends State<RecomendacionesWidget> {
  bool cargando = false;

  Future<void> _generarNuevoOutfit() async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) return;

    setState(() => cargando = true);

    try {
      final data = await OutfitService.generarOutfitAleatorio(idUsuario);

      RecomendacionCache.imagenOutfit = data['imagen_outfit'];
      RecomendacionCache.tonoPiel = data['tono_piel'];
      RecomendacionCache.imagenesPrendas = List<String>.from(data['imagenes_prendas'] ?? []);
      RecomendacionCache.colores = coloresPorTono[data['tono_piel']] ?? [];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar outfit')),
        );
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> _aceptarOutfit() async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) return;

    try {
      await OutfitService.aceptarOutfitGenerado(idUsuario);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outfit aceptado y guardado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptar outfit')),
      );
    }
  }

  final Map<String, List<Color>> coloresPorTono = {
    'Tipo I': [Color(0xFF000080), Color(0xFFFF00FF), Color(0xFFFFFFFF), Color(0xFF000000), Color(0xFFFA8072)],
    'Tipo II': [Color(0xFFFFC0CB), Color(0xFFE6E6FA), Color(0xFFDCDCDC), Color(0xFF9DC183), Color(0xFFF4A460)],
    'Tipo III': [Color(0xFFFF7F50), Color(0xFF98FF98), Color(0xFF87CEEB), Color(0xFF40E0D0), Color(0xFF8B4513)],
    'Tipo IV': [Color(0xFFE2725B), Color(0xFF808000), Color(0xFFA0522D), Color(0xFFFFDB58), Color(0xFF795548)],
    'Tipo V': [Color(0xFFB22222), Color(0xFF228B22), Color(0xFFFFBF00), Color(0xFF7B3F00), Color(0xFF000000)],
    'Tipo VI': [Color(0xFF0047AB), Color(0xFF50C878), Color(0xFF0A0A0A), Color(0xFF000000), Color(0xFF3E3E3E)],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Outfits', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('VESTIMENTA DEL DIA DE HOY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 16),

                // Imagen del outfit
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                    image: RecomendacionCache.imagenOutfit.isNotEmpty
                        ? DecorationImage(image: NetworkImage(RecomendacionCache.imagenOutfit), fit: BoxFit.cover)
                        : null,
                  ),
                  child: RecomendacionCache.imagenOutfit.isEmpty
                      ? Center(child: Text("Imagen no disponible"))
                      : null,
                ),

                SizedBox(height: 24),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _aceptarOutfit,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFF5CD890),
                        child: SvgPicture.asset('assets/icons/ropa-masculina.svg', height: 36),
                      ),
                    ),
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: cargando ? null : _generarNuevoOutfit,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFD8C95C),
                        child: cargando
                            ? CircularProgressIndicator(color: Colors.white)
                            : SvgPicture.asset('assets/icons/actualizar-flecha.svg', height: 30),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Lista de prendas
                Text("Prendas del Outfit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    RecomendacionCache.imagenesPrendas.length,
                    (index) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        RecomendacionCache.imagenesPrendas[index],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Colores recomendados
                Text("Colores que te favorecen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      RecomendacionCache.colores.length,
                      (index) => CircleAvatar(
                        radius: 25,
                        backgroundColor: RecomendacionCache.colores[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
