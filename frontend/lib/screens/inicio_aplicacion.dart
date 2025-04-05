import 'dart:async';
import 'package:flutter/material.dart';

import 'inicio_sesion_widget.dart'; // Asegúrate de que esta ruta sea correcta

class InicioAplicacionWidget extends StatefulWidget {
  @override
  _InicioAplicacionWidgetState createState() => _InicioAplicacionWidgetState();
}

class _InicioAplicacionWidgetState extends State<InicioAplicacionWidget> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InicioSesionWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 62, 80, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Outfit\nRecommender',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/LogoApp.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}
