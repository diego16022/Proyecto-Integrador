import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/services/models/prenda.dart';
import 'package:frontend/screens/NuevaprendaWidget.dart';
import 'package:frontend/services/prenda_service.dart';

class ClosetvirtualWidget extends StatefulWidget {
  @override
  _ClosetvirtualWidgetState createState() => _ClosetvirtualWidgetState();
}

class _ClosetvirtualWidgetState extends State<ClosetvirtualWidget> {
  List<Prenda> prendas = [];
  List<Prenda> todasLasPrendas = [];

  String _busqueda = '';
  String _categoriaSeleccionada = '';

  @override
  void initState() {
    super.initState();
    cargarPrendas();
  }

  Future<void> cargarPrendas() async {
    try {
      final resultado = await PrendaService.obtenerPrendas();
      setState(() {
        todasLasPrendas = resultado;
        _filtrarPrendas();
      });
    } catch (e) {
      print('Error al cargar prendas: $e');
    }
  }

  void _filtrarPrendas() {
    List<Prenda> filtradas = todasLasPrendas;

    if (_categoriaSeleccionada.isNotEmpty) {
      filtradas = filtradas.where((p) => p.tipo == _categoriaSeleccionada).toList();
    }

    if (_busqueda.isNotEmpty) {
      filtradas = filtradas.where((p) => p.nombre.toLowerCase().contains(_busqueda.toLowerCase())).toList();
    }

    setState(() {
      prendas = filtradas.take(6).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3DBE4),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Closet Virtual',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildCategoryChips(),
                  const SizedBox(height: 10),
                  _buildClothesGrid(),
                  const SizedBox(height: 30),
                  _buildLaundryLabel(),
                  const SizedBox(height: 12),
                  _buildLaundryRow(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF666666),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/buscar.svg', width: 24, height: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Buscar prendas...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _busqueda = value;
                _filtrarPrendas();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categorias = ['Camisa', 'Pantalon', 'Zapatos', 'Accesorios'];

    return Wrap(
      spacing: 10,
      children: categorias.map((categoria) {
        return _CategoryChip(
          label: categoria,
          seleccionado: _categoriaSeleccionada == categoria,
          onTap: () {
            setState(() {
              _categoriaSeleccionada =
                  _categoriaSeleccionada == categoria ? '' : categoria;
              _filtrarPrendas();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildClothesGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: prendas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, index) {
          final prenda = prendas[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: prenda.imagenUrl != null
                  ? Image.network(prenda.imagenUrl!, fit: BoxFit.cover)
                  : Container(color: const Color(0xFFD9D9D9)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLaundryLabel() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Prendas Lavando',
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildLaundryRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return Container(
            width: 44,
            height: 51,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4)
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      top: 12,
      right: 12,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: NuevaPrendaWidget(),
              );
            },
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFF5BD790),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset('assets/icons/mas.svg'),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool seleccionado;
  final Function() onTap;

  const _CategoryChip({
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        backgroundColor: seleccionado ? const Color(0xFF5BD790) : Colors.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        label: Text(
          label,
          style: TextStyle(
            color: seleccionado ? Colors.white : const Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
