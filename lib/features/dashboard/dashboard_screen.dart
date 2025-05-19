import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/shared/widgets/glass_app_bar.dart';
import 'package:vida_organizada/shared/widgets/glass_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: Text('Dashboard'),
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado de bienvenida
                  Text(
                    'Hola, Usuario',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tarjetas de acceso rápido
                  const Text(
                    'Accesos rápidos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tarjeta de finanzas
                  _buildMenuCard(
                    'Finanzas',
                    'Gestiona tus ingresos y gastos',
                    Icons.account_balance_wallet_outlined,
                    AppThemes.primaryBlue,
                    () => Navigator.pushNamed(context, '/finanzas'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tarjeta de metas
                  _buildMenuCard(
                    'Metas',
                    'Define y sigue tus objetivos',
                    Icons.flag_outlined,
                    Colors.orangeAccent, 
                    () => Navigator.pushNamed(context, '/metas'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tarjeta de proyectos
                  _buildMenuCard(
                    'Proyectos',
                    'Gestiona tus proyectos y tareas',
                    Icons.task_alt_outlined,
                    Colors.purpleAccent,
                    () => Navigator.pushNamed(context, '/proyectos'),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tarjeta de navegador
                  _buildMenuCard(
                    'Navegador',
                    'Accede a enlaces y contenido web',
                    Icons.language_outlined,
                    Colors.tealAccent,
                    () => Navigator.pushNamed(context, '/navegador'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const GlassNavigationBar(),
    );
  }
  
  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '¡Buenos días! ¿Listo para un día productivo?';
    } else if (hour < 18) {
      return '¡Buenas tardes! Sigue avanzando en tus metas.';
    } else {
      return '¡Buenas noches! Revisa tu progreso del día.';
    }
  }
}