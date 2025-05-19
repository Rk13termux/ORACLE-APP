import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/features/dashboard/widgets/dashboard_card.dart';
import 'package:vida_organizada/features/dashboard/widgets/stats_card.dart';
import 'package:vida_organizada/features/dashboard/widgets/task_progress_card.dart';
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
      appBar: GlassAppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/ajustes');
            },
          ),
        ],
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _WelcomeHeader(),
                      const SizedBox(height: 24),
                      
                      // Tarjetas de estadísticas principales
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            StatsCard(
                              title: 'Finanzas',
                              value: '\$2,450',
                              subtitle: 'Balance actual',
                              icon: Icons.account_balance_wallet,
                              color: Colors.blueAccent,
                              onTap: () => Navigator.pushNamed(context, '/finanzas'),
                            ),
                            StatsCard(
                              title: 'Metas',
                              value: '7',
                              subtitle: '2 completadas',
                              icon: Icons.flag_outlined,
                              color: Colors.orangeAccent,
                              onTap: () => Navigator.pushNamed(context, '/metas'),
                            ),
                            StatsCard(
                              title: 'Proyectos',
                              value: '3',
                              subtitle: 'En progreso',
                              icon: Icons.task_alt,
                              color: Colors.purpleAccent,
                              onTap: () => Navigator.pushNamed(context, '/proyectos'),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Progreso y estadísticas personales
                      const Text(
                        'Tu progreso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(),
                      
                      const SizedBox(height: 16),
                      
                      // Tarjetas de progreso de tareas
                      TaskProgressCard(
                        title: 'Progreso mensual',
                        progress: 0.68,
                        value: '68%',
                        subtitle: '15 días restantes',
                        color: AppThemes.primaryBlue,
                      ).animate().fadeIn(delay: 100.ms).slideX(),
                      
                      const SizedBox(height: 16),
                      
                      TaskProgressCard(
                        title: 'Metas completadas',
                        progress: 0.34,
                        value: '34%',
                        subtitle: '3 de 7 metas',
                        color: AppThemes.tertiaryColor,
                      ).animate().fadeIn(delay: 200.ms).slideX(),
                      
                      const SizedBox(height: 24),
                      
                      // Sección de accesos directos
                      const Text(
                        'Accesos directos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(),
                      
                      const SizedBox(height: 16),
                      
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          DashboardCard(
                            title: 'Finanzas',
                            icon: Icons.account_balance_wallet_outlined,
                            color: Colors.blueAccent,
                            onTap: () => Navigator.pushNamed(context, '/finanzas'),
                          ).animate().fadeIn(delay: 300.ms).scale(),
                          
                          DashboardCard(
                            title: 'Metas',
                            icon: Icons.flag_outlined,
                            color: Colors.orangeAccent,
                            onTap: () => Navigator.pushNamed(context, '/metas'),
                          ).animate().fadeIn(delay: 400.ms).scale(),
                          
                          DashboardCard(
                            title: 'Proyectos',
                            icon: Icons.task_alt_outlined,
                            color: Colors.purpleAccent,
                            onTap: () => Navigator.pushNamed(context, '/proyectos'),
                          ).animate().fadeIn(delay: 500.ms).scale(),
                          
                          DashboardCard(
                            title: 'Navegador',
                            icon: Icons.language_outlined,
                            color: Colors.teal,
                            onTap: () => Navigator.pushNamed(context, '/navegador'),
                          ).animate().fadeIn(delay: 600.ms).scale(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const GlassNavigationBar(),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, Usuario',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          _getGreeting(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: -0.2, end: 0),
      ],
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