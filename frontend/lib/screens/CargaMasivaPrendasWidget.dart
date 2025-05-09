import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/services/auth_service.dart' as auth;
import 'package:frontend/services/prenda_service.dart';

enum TipoPrendaEnum { Camisa, Pantalon, Zapatos, Accesorios }

class CargaMasivaPrendasWidget extends StatefulWidget {
  @override
  _CargaMasivaPrendasWidgetState createState() => _CargaMasivaPrendasWidgetState();
}

class _CargaMasivaPrendasWidgetState extends State<CargaMasivaPrendasWidget> {
  List<File> _imagenesSeleccionadas = [];
  TipoPrendaEnum? _tipoSeleccionado;
  bool _cargando = false;

  Future<void> _seleccionarImagenes() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.paths.isNotEmpty) {
        setState(() {
          _imagenesSeleccionadas = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      print("Error al seleccionar imágenes: $e");
    }
  }

  Future<void> _subirImagenes() async {
    if (_tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes seleccionar el tipo de prenda.")),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      await PrendaService.cargarPrendasMasivasDesdeFile(
        _imagenesSeleccionadas,
        auth.SesionUsuario.idUsuario!,
        _tipoSeleccionado!.name,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Carga masiva completada exitosamente")),
      );

      // Esperar un momento para mostrar el SnackBar antes de volver
      await Future.delayed(const Duration(milliseconds: 600));

      // Regresar a la pantalla anterior (ClosetvirtualWidget)
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al subir: $e")),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carga Masiva de Prendas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<TipoPrendaEnum>(
              value: _tipoSeleccionado,
              decoration: InputDecoration(
                labelText: "Tipo de prenda",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: TipoPrendaEnum.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _tipoSeleccionado = value);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _seleccionarImagenes,
              child: const Text("Seleccionar imágenes"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: _imagenesSeleccionadas.map((file) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(file, fit: BoxFit.cover),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _imagenesSeleccionadas.isNotEmpty ? _subirImagenes : null,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Subir prendas"),
                  ),
          ],
        ),
      ),
    );
  }
}
