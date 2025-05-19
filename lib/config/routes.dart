import 'package:flutter/material.dart';
import 'package:vida_organizada/features/dashboard/dashboard_screen.dart';
import 'package:vida_organizada/features/finanzas/finanzas_screen.dart';
import 'package:vida_organizada/features/metas/metas_screen.dart';
import 'package:vida_organizada/features/proyectos/proyectos_screen.dart';
import 'package:vida_organizada/features/ajustes/ajustes_screen.dart';
import 'package:vida_organizada/features/navegador/navegador_screen.dart';

class AppRouter {
  // Rutas de navegación
  static const String dashboard = '/';
  static const String finanzas = '/finanzas';
  static const String metas = '/metas';
  static const String proyectos = '/proyectos';
  static const String navegador = '/navegador';
  static const String ajustes = '/ajustes';
  
  // Generador de rutas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case finanzas:
        return MaterialPageRoute(builder: (_) => const FinanzasScreen());
      case metas:
        return _buildPlaceholderRoute('Metas', settings);
      case proyectos:
        return _buildPlaceholderRoute('Proyectos', settings);
      case navegador:
        return _buildPlaceholderRoute('Navegador', settings);
      case ajustes:
        return _buildPlaceholderRoute('Ajustes', settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No se encontró la ruta: ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  // Constructor de rutas temporales para módulos no implementados
  static Route<dynamic> _buildPlaceholderRoute(String title, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Colors.amber,
              ),
              SizedBox(height: 24),
              Text(
                'Módulo en desarrollo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Esta funcionalidad estará disponible próximamente',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}