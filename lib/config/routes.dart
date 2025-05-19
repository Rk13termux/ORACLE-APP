import 'package:flutter/material.dart';
import 'package:vida_organizada/features/dashboard/dashboard_screen.dart';
import 'package:vida_organizada/features/finanzas/finanzas_screen.dart';
import 'package:vida_organizada/features/metas/metas_screen.dart';
import 'package:vida_organizada/features/navegador/navegador_screen.dart';
import 'package:vida_organizada/features/proyectos/proyectos_screen.dart';
import 'package:vida_organizada/features/ajustes/ajustes_screen.dart';

// Clase para manejar las rutas de la aplicación
class AppRouter {
  // Rutas nombradas principales
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String finanzas = '/finanzas';
  static const String metas = '/metas';
  static const String proyectos = '/proyectos';
  static const String navegador = '/navegador';
  static const String ajustes = '/ajustes';

  // Método para generar rutas
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
      case dashboard:
        return _buildRoute(const DashboardScreen(), settings);
      case finanzas:
        return _buildRoute(const FinanzasScreen(), settings);
      case metas:
        return _buildRoute(const MetasScreen(), settings);
      case proyectos:
        return _buildRoute(const ProyectosScreen(), settings);
      case navegador:
        final String? url = settings.arguments as String?;
        return _buildRoute(NavegadorScreen(initialUrl: url), settings);
      case ajustes:
        return _buildRoute(const AjustesScreen(), settings);
      default:
        return _buildRoute(
          const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
          settings,
        );
    }
  }

  // Método para construir rutas con transiciones personalizadas
  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}