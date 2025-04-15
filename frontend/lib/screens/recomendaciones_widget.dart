import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/outfit_service.dart';
import '../services/auth_service.dart';

class RecomendacionesWidget extends StatefulWidget {
  @override
  _RecomendacionesWidgetState createState() => _RecomendacionesWidgetState();
}

class _RecomendacionesWidgetState extends State<RecomendacionesWidget> {
  String imagenOutfit = "";
  String tonoPiel = "";
  List<String> imagenesPrendas = [];
  List<Color> colores = [];
  bool cargando = false;

  final Map<String, List<Color>> coloresPorTono = {
    'Tipo_I': [Color(0xFF000080), Color(0xFFFF00FF), Color(0xFFFFFFFF), Color(0xFF000000), Color(0xFFFA8072)],
    'Tipo_II': [Color(0xFFFFC0CB), Color(0xFFE6E6FA), Color(0xFFDCDCDC), Color(0xFF9DC183), Color(0xFFF4A460)],
    'Tipo_III': [Color(0xFFFF7F50), Color(0xFF98FF98), Color(0xFF87CEEB), Color(0xFF40E0D0), Color(0xFF8B4513)],
    'Tipo_IV': [Color(0xFFE2725B), Color(0xFF808000), Color(0xFFA0522D), Color(0xFFFFDB58), Color(0xFF795548)],
    'Tipo_V': [Color(0xFFB22222), Color(0xFF228B22), Color(0xFFFFBF00), Color(0xFF7B3F00), Color(0xFF000000)],
    'Tipo_VI': [Color(0xFF0047AB), Color(0xFF50C878), Color(0xFF0A0A0A), Color(0xFF000000), Color(0xFF3E3E3E)],
  };

  Future<void> _generarNuevoOutfit() async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) return;

    setState(() => cargando = true);

    try {
      final data = await OutfitService.generarOutfitAleatorio(idUsuario);
      if (!mounted) return;

      setState(() {
        imagenOutfit = data['imagen_outfit'];
        tonoPiel = data['tono_piel'];
        imagenesPrendas = List<String>.from(data['imagenes_prendas'] ?? []);
        colores = coloresPorTono[tonoPiel] ?? [];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar outfit')),
      );
    } finally {
      if (!mounted) return;
      setState(() => cargando = false);
    }
  }

  Future<void> _aceptarOutfit() async {
    final idUsuario = SesionUsuario.idUsuario;
    if (idUsuario == null) return;

    try {
      await OutfitService.aceptarOutfitGenerado(idUsuario);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outfit aceptado y guardado')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptar outfit')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _generarNuevoOutfit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Outfits', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('VESTIMENTA DEL DÍA DE HOY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 16),
                imagenOutfit.isNotEmpty
                    ? Image.network(imagenOutfit, height: 250, fit: BoxFit.cover)
                    : Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(child: Text("Imagen no disponible")),
                      ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _aceptarOutfit,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFF5CD890),
                        child: SvgPicture.asset(
                          'assets/icons/ropa-masculina.svg',
                          height: 36,
                        ),
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
                Text("Colores que te favorecen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    colores.length,
                    (index) => CircleAvatar(radius: 25, backgroundColor: colores[index]),
                  ),
                ),
                SizedBox(height: 30),
                Text("Prendas Seleccionadas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: imagenesPrendas.map((url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(url, height: 80, width: 80, fit: BoxFit.cover),
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
