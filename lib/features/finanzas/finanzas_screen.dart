import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/shared/widgets/glass_app_bar.dart';

class FinanzasScreen extends StatelessWidget {
  const FinanzasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: const Text('Finanzas'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF121212),
              Color(0xFF1A237E),
              Color(0xFF121212),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'Módulo de finanzas en desarrollo',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}