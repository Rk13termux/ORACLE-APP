import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/shared/widgets/glass_app_bar.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: const Text('Ajustes'),
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text('Tema oscuro', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Implementar cambio de tema
                },
              ),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Implementar cambio de notificaciones
                },
              ),
            ),
            const Divider(color: Colors.white24),
            const ListTile(
              title: Text('Versión de la aplicación', style: TextStyle(color: Colors.white)),
              subtitle: Text('1.0.0', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}