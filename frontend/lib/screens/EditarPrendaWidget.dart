import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/prenda_service.dart';
import 'package:frontend/services/models/prenda.dart';
import 'package:frontend/services/auth_service.dart' as auth;
import 'package:collection/collection.dart';



enum TipoPrendaEnum { Camisa, Pantalon, Zapatos, Accesorios }
enum TemporadaEnum { Verano, Invierno, Otono, Primavera, Todo_el_ano }
enum EstadoUsoEnum { Nuevo, Poco_usado, Usado, Viejo }

String mapTemporada(TemporadaEnum temporada) {
  switch (temporada) {
    case TemporadaEnum.Verano: return "Verano";
    case TemporadaEnum.Invierno: return "Invierno";
    case TemporadaEnum.Otono: return "Otoño";
    case TemporadaEnum.Primavera: return "Primavera";
    case TemporadaEnum.Todo_el_ano: return "Todo el año";
  }
}

final List<Map<String, dynamic>> estilos = [
  {"id": 2, "nombre": "Regular Fit"},
  {"id": 3, "nombre": "Slim Fit"},
  {"id": 4, "nombre": "Tailored Fit"},
  {"id": 5, "nombre": "Custom Fit"},
  {"id": 6, "nombre": "Loose Fit"},
  {"id": 7, "nombre": "Wide Leg"},
];

final List<Map<String, dynamic>> ocasiones = [
  {"id": 1, "nombre": "Formal"},
  {"id": 2, "nombre": "Deportivo"},
  {"id": 3, "nombre": "Fiesta"},
  {"id": 4, "nombre": "Cualquier Ocasión"},
  {"id": 5, "nombre": "Casual"},
];

final List<Color> coloresPermitidos = [
  Color(0xFF000080), Color(0xFFFF00FF), Color(0xFFFFFFFF), Color(0xFF000000), Color(0xFFFA8072),
  Color(0xFFFFC0CB), Color(0xFFE6E6FA), Color(0xFFDCDCDC), Color(0xFF9DC183), Color(0xFFF4A460),
  Color(0xFFFF7F50), Color(0xFF98FF98), Color(0xFF87CEEB), Color(0xFF40E0D0), Color(0xFF8B4513),
  Color(0xFFE2725B), Color(0xFF808000), Color(0xFFA0522D), Color(0xFFFFDB58), Color(0xFFA0522D),
  Color(0xFFB22222), Color(0xFF228B22), Color(0xFFFFBF00), Color(0xFF7B3F00),
  Color(0xFF0047AB), Color(0xFF50C878), Color(0xFF0A0A0A), Color(0xFF3E3E3E),
];

class EditarPrendaWidget extends StatefulWidget {
  final Prenda prenda;
  final VoidCallback? onPrendaActualizada;

  const EditarPrendaWidget({required this.prenda, this.onPrendaActualizada});

  @override
  State<EditarPrendaWidget> createState() => _EditarPrendaWidgetState();
}

class _EditarPrendaWidgetState extends State<EditarPrendaWidget> {
  String? _nombre;
  TipoPrendaEnum? _tipo;
  TemporadaEnum? _temporada;
  EstadoUsoEnum? _estado;
  Color? _color;
  int? _idEstiloSeleccionado;
  int? _idOcasionSeleccionada;
  File? _imageFile;
  ImageProvider? _imagen;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nombre = widget.prenda.nombre;
    _tipo = TipoPrendaEnum.values.firstWhereOrNull((e) => e.name == widget.prenda.tipo);
    _temporada = TemporadaEnum.values.firstWhereOrNull((e) => mapTemporada(e) == widget.prenda.temporada);
    _estado = EstadoUsoEnum.values.firstWhereOrNull((e) => e.name.replaceAll('_', ' ') == widget.prenda.estadoUso);
    _color = Color(int.parse("0xff${widget.prenda.color.replaceAll('#', '')}"));
    _idEstiloSeleccionado = widget.prenda.idEstilo;
    if (widget.prenda.imagenUrl != null) {
      _imagen = NetworkImage(widget.prenda.imagenUrl!);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagen = FileImage(_imageFile!);
      });
    }
  }

  Future<void> _guardarCambios() async {
    try {
      String? uploadedImageUrl = widget.prenda.imagenUrl;
      if (_imageFile != null) {
        uploadedImageUrl = await PrendaService.uploadImage(
          _imageFile!,
          auth.SesionUsuario.idUsuario!,
        );
      }

      await PrendaService.actualizarPrenda(Prenda(
        id: widget.prenda.id,
        nombre: _nombre!,
        tipo: _tipo!.name,
        temporada: mapTemporada(_temporada!),
        estadoUso: _estado!.name.replaceAll('_', ' '),
        color: '#${_color!.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        imagenUrl: uploadedImageUrl,
        idUsuario: auth.SesionUsuario.idUsuario!,
        idEstilo: _idEstiloSeleccionado!,
      ));

      if (_idOcasionSeleccionada != null) {
        await PrendaService.asociarOcasion(widget.prenda.id, _idOcasionSeleccionada!);
      }

      widget.onPrendaActualizada?.call();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error actualizando prenda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar cambios")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Editar Prenda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
              const SizedBox(height: 10),
              TextField(
                controller: TextEditingController(text: _nombre),
                onChanged: (val) => _nombre = val,
                decoration: _inputDecoration('Nombre'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    image: _imagen != null ? DecorationImage(image: _imagen!, fit: BoxFit.cover) : null,
                  ),
                  child: _imagen == null
                      ? const Center(child: Icon(Icons.camera_alt, size: 50, color: Colors.grey))
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              _buildDropdown('Tipo', TipoPrendaEnum.values, _tipo, (val) => setState(() => _tipo = val)),
              _buildDropdown('Estado de uso', EstadoUsoEnum.values, _estado, (val) => setState(() => _estado = val)),
              _buildDropdown('Temporada', TemporadaEnum.values, _temporada, (val) => setState(() => _temporada = val)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Selecciona un color"),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: _color ?? Colors.blue,
                          availableColors: coloresPermitidos,
                          onColorChanged: (color) => setState(() => _color = color),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _color ?? const Color(0xFF666666),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Color', style: TextStyle(color: Colors.white)),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _color ?? Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildDropdownForm("Estilo (Fit)", estilos, _idEstiloSeleccionado, (val) => setState(() => _idEstiloSeleccionado = val)),
              _buildDropdownForm("Ocasión", ocasiones, _idOcasionSeleccionada, (val) => setState(() => _idOcasionSeleccionada = val)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _botonRedondo(color: Colors.green, icono: Icons.check, onTap: _guardarCambios),
                  _botonRedondo(color: Colors.red, icono: Icons.close, onTap: () => Navigator.pop(context)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF666666),
      labelStyle: const TextStyle(color: Color(0xFF9D9A9A)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildDropdown<T>(String label, List<T> items, T? value, Function(T?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<T>(
        decoration: _inputDecoration(label),
        value: value,
        items: items.map((e) => DropdownMenuItem<T>(
          value: e,
          child: Text(e.toString().split('.').last),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownForm(String label, List<Map<String, dynamic>> items, int? selectedValue, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<int>(
        decoration: _inputDecoration(label),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem<int>(
            value: item["id"],
            child: Text(item["nombre"]),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _botonRedondo({required Color color, required IconData icono, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 25,
        child: Icon(icono, color: Colors.white),
      ),
    );
  }
}
