import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/services/models/recomendacion_cache.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/outfit_service.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    _generarSiNoHayRecomendacion();
  }

  Future<void> _generarSiNoHayRecomendacion() async {
    if (!RecomendacionCache.hayRecomendacion()) {
      final idUsuario = SesionUsuario.idUsuario;
      if (idUsuario == null) return;

      setState(() => cargando = true);
      try {
        final data = await OutfitService.generarOutfitAleatorio(idUsuario);
        RecomendacionCache.imagenOutfit = data['imagen_outfit'];
        RecomendacionCache.tonoPiel = data['tono_piel'];
        RecomendacionCache.imagenesPrendas =
            List<String>.from(data['imagenes_prendas'] ?? []);
        RecomendacionCache.colores =
            coloresPorTono[data['tono_piel']] ?? [];
      } catch (e) {
        print("Error generando outfit: $e");
      } finally {
        if (mounted) setState(() => cargando = false);
      }
    }
  }

  final Map<String, List<Color>> coloresPorTono = {
    'Tipo I': [
      Color(0xFF000080),
      Color(0xFFFF00FF),
      Color(0xFFFFFFFF),
      Color(0xFF000000),
      Color(0xFFFA8072)
    ],
    'Tipo II': [
      Color(0xFFFFC0CB),
      Color(0xFFE6E6FA),
      Color(0xFFDCDCDC),
      Color(0xFF9DC183),
      Color(0xFFF4A460)
    ],
    'Tipo III': [
      Color(0xFFFF7F50),
      Color(0xFF98FF98),
      Color(0xFF87CEEB),
      Color(0xFF40E0D0),
      Color(0xFF8B4513)
    ],
    'Tipo IV': [
      Color(0xFFE2725B),
      Color(0xFF808000),
      Color(0xFFA0522D),
      Color(0xFFFFDB58),
      Color(0xFF795548)
    ],
    'Tipo V': [
      Color(0xFFB22222),
      Color(0xFF228B22),
      Color(0xFFFFBF00),
      Color(0xFF7B3F00),
      Color(0xFF000000)
    ],
    'Tipo VI': [
      Color(0xFF0047AB),
      Color(0xFF50C878),
      Color(0xFF0A0A0A),
      Color(0xFF000000),
      Color(0xFF3E3E3E)
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tieneTono = RecomendacionCache.tonoPiel != null;

    return Scaffold(
      backgroundColor: const Color(0xFFD3DBE4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (tieneTono) ...[
              const Text(
                'Recomendación de Hoy',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                    image: RecomendacionCache.hayRecomendacion()
                        ? DecorationImage(
                            image: NetworkImage(
                                RecomendacionCache.imagenOutfit),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: !RecomendacionCache.hayRecomendacion()
                      ? SvgPicture.asset(
                          'assets/icons/armarios.svg',
                          height: 100,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Look Casual para el Día',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      color: Color(0xFF333333)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/home', arguments: 3);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5BD790),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                  ),
                  child: const Text(
                    'Ver Detalles',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            //  Ropa Utilizada Antes
            const Text(
              'Ropa Utilizada Antes',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  RecomendacionCache.imagenesPrendas.length,
                  (index) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      RecomendacionCache.imagenesPrendas[index],
                      width: 44,
                      height: 51,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar lógica para "Enviar a Lavar"
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("¡Prendas enviadas a lavar!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5BD790),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 32),
                ),
                child: const Text(
                  'Enviar a Lavar',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //  Colores más utilizados
            const Text(
              'Colores más Utilizados',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  RecomendacionCache.colores.length,
                  (index) => CircleAvatar(
                    radius: 20,
                    backgroundColor: RecomendacionCache.colores[index],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
