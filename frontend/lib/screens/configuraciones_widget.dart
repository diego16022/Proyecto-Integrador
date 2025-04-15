import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/usuario_service.dart';

class ConfiguracionUsuarioWidget extends StatefulWidget {
  @override
  _ConfiguracionUsuarioWidgetState createState() => _ConfiguracionUsuarioWidgetState();
}

class _ConfiguracionUsuarioWidgetState extends State<ConfiguracionUsuarioWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idiomaController = TextEditingController();
  final TextEditingController _notificacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = SesionUsuario.nombre ?? '';
    _emailController.text = SesionUsuario.email ?? '';
  }

  Future<void> _guardarCambios() async {
    try {
      await UsuarioServices.actualizarUsuario(
        idUsuario: SesionUsuario.idUsuario!,
        nombre: _nombreController.text,
        email: _emailController.text,
        contrasena: _passwordController.text,

      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cambios guardados exitosamente")),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar los cambios")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBD5E1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Configuración de Usuario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              _buildTextField(_nombreController, 'Nombre Completo'),
              SizedBox(height: 16),

              _buildTextField(_emailController, 'Correo Electrónico'),
              SizedBox(height: 16),

              _buildTextField(_passwordController, 'Contraseña', isPassword: true),
              SizedBox(height: 16),

              _buildTextField(_idiomaController, 'Idioma'),
              SizedBox(height: 16),

              _buildTextField(_notificacionController, 'Notificaciones'),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _guardarCambios,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Color(0xFF666666),
        labelStyle: TextStyle(color: Color(0xFF9D9A9A)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
