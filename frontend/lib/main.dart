import 'package:flutter/material.dart';
import 'package:frontend/screens/closetvirtual_widget.dart';
import 'screens/inicio_aplicacion.dart';
import 'screens/inicio_sesion_widget.dart';
import 'screens/crear_cuenta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  InicioAplicacionWidget(), // Arranca con splash
      routes: {
        '/login': (context) => const InicioSesionWidget(),
        '/register': (context) => const CrearCuentaWidget(),
        '/closet': (context) => ClosetvirtualWidget(),
      },
    );
  }
}
