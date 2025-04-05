import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/services/auth_service.dart';



class CrearCuentaWidget extends StatefulWidget {
  const CrearCuentaWidget({super.key});

  @override
  State<CrearCuentaWidget> createState() => _CrearCuentaWidgetState();
}

class _CrearCuentaWidgetState extends State<CrearCuentaWidget> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registrar() async {
    final nombre = nombreController.text.trim();
    final email = emailController.text.trim();
    final contrasena = passwordController.text;
    final confirmar = confirmPasswordController.text;

    if (nombre.isEmpty || email.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
      _mostrarMensaje("Por favor completa todos los campos");
      return;
    }

    if (contrasena != confirmar) {
      _mostrarMensaje("Las contraseñas no coinciden");
      return;
    }

    try {
      final response = await AuthService.registrarUsuario(nombre, email, contrasena);
      _mostrarMensaje("Usuario registrado con éxito");
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      _mostrarMensaje(e.toString());
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3DBE4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Crea tu cuenta', style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
            const SizedBox(height: 10),
            const Text('Únete a la moda inteligente y personalizada', style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 30),

            _inputField('Nombre Completo', controller: nombreController),
            const SizedBox(height: 15),
            _inputField('Correo Electrónico', controller: emailController),
            const SizedBox(height: 15),
            _inputField('Contraseña', controller: passwordController, obscure: true),
            const SizedBox(height: 15),
            _inputField('Confirmar Contraseña', controller: confirmPasswordController, obscure: true),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5BD790),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                ),
                child: const Text('Registrarse', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset('assets/icons/facebook.svg', width: 40, height: 40),
                SvgPicture.asset('assets/icons/instagram.svg', width: 40, height: 40),
                SvgPicture.asset('assets/icons/gmail.svg', width: 40, height: 40),
              ],
            ),
            const SizedBox(height: 25),

            const Text('¿Ya tienes cuenta? Inicia Sesión', style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, {bool obscure = false, required TextEditingController controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(fontFamily: 'Montserrat',color: Colors.white70,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
