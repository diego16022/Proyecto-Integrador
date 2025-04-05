import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/services/prenda_service.dart';


enum TipoPrendaEnum { Camisa, Pantalon, Zapatos, Accesorios }
enum TemporadaEnum { Verano, Invierno, Otono, Primavera, Todo_el_ano }
enum EstadoUsoEnum { Nuevo, Poco_usado, Usado, Viejo }

String mapTemporada(TemporadaEnum temporada) {
  switch (temporada) {
    case TemporadaEnum.Verano:
      return "Verano";
    case TemporadaEnum.Invierno:
      return "Invierno";
    case TemporadaEnum.Otono:
      return "Otoño";
    case TemporadaEnum.Primavera:
      return "Primavera";
    case TemporadaEnum.Todo_el_ano:
      return "Todo el año";
  }
}

class NuevaPrendaWidget extends StatefulWidget {
  @override
  _NuevaPrendaWidgetState createState() => _NuevaPrendaWidgetState();
}

class _NuevaPrendaWidgetState extends State<NuevaPrendaWidget> {
  TipoPrendaEnum? _tipo;
  TemporadaEnum? _temporada;
  EstadoUsoEnum? _estado;
  String? _nombre;
  Color? _color;
  File? _imageFile;
  ImageProvider? _imagen;
  int? _idEstiloSeleccionado;

  final picker = ImagePicker();

  


  final List<Map<String, dynamic>> estilos = [
    {"id": 2, "nombre": "Regular Fit"},
    {"id": 3, "nombre": "Slim Fit"},
    {"id": 4, "nombre": "Tailored Fit"},
    {"id": 5, "nombre": "Custom Fit"},
    {"id": 6, "nombre": "Loose Fit"},
    {"id": 7, "nombre": "Wide Leg"},
  ];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagen = FileImage(_imageFile!);
      });
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
              const Text(
                'Agregar Nueva Prenda',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                onChanged: (value) => _nombre = value,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: const Color(0xFF666666),
                  labelStyle: const TextStyle(color: Color(0xFF9D9A9A)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    image: _imagen != null
                        ? DecorationImage(image: _imagen!, fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imagen == null
                      ? const Center(
                          child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              _buildDropdown<TipoPrendaEnum>('Tipo', TipoPrendaEnum.values, _tipo,
                  (val) => setState(() => _tipo = val)),

              _buildDropdown<EstadoUsoEnum>('Estado de uso', EstadoUsoEnum.values, _estado,
                  (val) => setState(() => _estado = val)),

              _buildDropdown<TemporadaEnum>('Temporada', TemporadaEnum.values, _temporada,
                  (val) => setState(() => _temporada = val)),

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

              // Dropdown de Estilo (Fit)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Estilo (Fit)",
                    filled: true,
                    fillColor: const Color(0xFF666666),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  value: _idEstiloSeleccionado,
                  items: estilos.map((estilo) {
                    return DropdownMenuItem<int>(
                      value: estilo["id"],
                      child: Text(estilo["nombre"]),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _idEstiloSeleccionado = val;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _botonRedondo(
                    color: Colors.green,
                    icono: Icons.check,
                    onTap: () async {
                      try {
                        String? uploadedImageUrl;

                        if (_imageFile != null) {
                          uploadedImageUrl = await PrendaService.uploadImage(_imageFile!, 1);
                        }
                        print("_nombre: $_nombre");
                        print("_tipo: $_tipo");
                        print("_estado: $_estado");
                        print("_temporada: $_temporada");
                        print("_color: $_color");
                        print("_idEstiloSeleccionado: $_idEstiloSeleccionado");
                        await PrendaService.crearPrenda(
                          nombre: _nombre!,
                          tipo: _tipo!.name.toString().split('.').last,
                          color: '#${_color!.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                          temporada: mapTemporada(_temporada!),
                          estadoUso: _estado!.name.toString().split('.').last.replaceAll('_', ' '),
                          idUsuario: 1,
                          imagenUrl: uploadedImageUrl,
                          idEstilo: _idEstiloSeleccionado!,
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error al guardar la prenda")),
                        );
                      }
                    },
                  ),
                  _botonRedondo(
                    color: Colors.red,
                    icono: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
      String label, List<T> items, T? value, Function(T?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF666666),
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: value,
        items: items
            .map((e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString().split('.').last),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _botonRedondo({
    required Color color,
    required IconData icono,
    required Function() onTap,
  }) {
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
