import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_content.dart';
import 'closetvirtual_widget.dart';
import 'analisi_cromatico.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  const EmptyScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Pantalla $title en construcción',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
