import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_content.dart'; 
import 'closetvirtual_widget.dart';
import 'analisi_cromatico.dart';
import 'recomendaciones_widget.dart';
import 'configuraciones_widget.dart';


class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int selectedIndex = 0;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      selectedIndex = args;
    }
  }

  final List<String> iconPaths = [
    'assets/icons/casa_home.svg',
    'assets/icons/armarios.svg',
    'assets/icons/bronceado.svg',
    'assets/icons/traje.svg',
    'assets/icons/configuraciones.svg',
  ];

  final List<Widget> _screens = [
    HomeContent(),              
    ClosetvirtualWidget(),
    AnalisisCromaticoWidget(),
    RecomendacionesWidget(),
    ConfiguracionUsuarioWidget(),
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  Widget _buildCustomBottomBar() {
    return Container(
      height: 90,
      width: double.infinity,
      child: Stack(
        children: [
          // Fondo de la barra
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Íconos + elipse activa
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(iconPaths.length, (index) {
                final isActive = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isActive)
                          SvgPicture.asset(
                            'assets/icons/ellipse_active.svg',
                            height: 70,
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: isActive ? 6 : 0),
                          child: SvgPicture.asset(
                            iconPaths[index],
                            height: isActive ? 28 : 30,
                            colorFilter: isActive
                                ? null
                                : const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
