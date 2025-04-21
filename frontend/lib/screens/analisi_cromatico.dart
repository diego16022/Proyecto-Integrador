import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/usuario_service.dart';
import 'package:frontend/services/auth_service.dart'; 

final Map<String, List<Color>> coloresPorTono = {
  'Tipo I': [
    Color(0xFF000080), Color(0xFFFF00FF), Color(0xFFFFFFFF), Color(0xFF000000)
  ],
  'Tipo II': [
    Color(0xFFFFC0CB), Color(0xFFE6E6FA), Color(0xFFDCDCDC), Color(0xFF9DC183)
  ],
  'Tipo III': [
    Color(0xFFFF7F50), Color(0xFF98FF98), Color(0xFF87CEEB), Color(0xFF40E0D0)
  ],
  'Tipo IV': [
    Color(0xFFE2725B), Color(0xFF808000), Color(0xFFA0522D), Color(0xFFFFDB58)
  ],
  'Tipo V': [
    Color(0xFFB22222), Color(0xFF228B22), Color(0xFFFFBF00), Color(0xFF7B3F00)
  ],
  'Tipo VI': [
    Color(0xFF0047AB), Color(0xFF50C878), Color(0xFF8A2BE2), Color(0xFFC0C0C0)
  ],
};

class AnalisisCromaticoWidget extends StatefulWidget {
  @override
  _AnalisisCromaticoWidgetState createState() => _AnalisisCromaticoWidgetState();
}

class _AnalisisCromaticoWidgetState extends State<AnalisisCromaticoWidget> {
  File? _imageFile;
  ImageProvider? _imagen;
  final picker = ImagePicker();
  bool _subiendo = false;
  String? _tonoPielDetectado;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagen = FileImage(_imageFile!);
      });
    }
  }

  Future<void> _analizarFoto() async {
    if (_imageFile == null || SesionUsuario.idUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una imagen primero')),
      );
      return;
    }

    setState(() => _subiendo = true);

    try {
      final resultado = await UsuarioServices.realizarAnalisisCromatico(
        _imageFile!,
        SesionUsuario.idUsuario!,
      );

      setState(() {
        _tonoPielDetectado = resultado['tono_piel'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Análisis cromático guardado exitosamente!')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el análisis cromático')),
      );
    } finally {
      setState(() => _subiendo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = coloresPorTono[_tonoPielDetectado] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Análisis Cromático',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: _imagen != null
                        ? DecorationImage(image: _imagen!, fit: BoxFit.cover)
                        : null,
                    color: Colors.grey[200],
                  ),
                  child: _imagen == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, size: 60, color: Colors.black),
                            SizedBox(height: 10),
                            Text("Capturar Tono de Piel", style: TextStyle(fontSize: 16))
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Capturar Color'),
                ),
                ElevatedButton(
                  onPressed: _subiendo ? null : _analizarFoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: _subiendo
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Generar Análisis'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Colores que te favorecen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: colores
                    .map((color) => CircleAvatar(
                          radius: 25,
                          backgroundColor: color,
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
