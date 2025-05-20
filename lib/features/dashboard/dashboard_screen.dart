import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class AppRouter {
  static const String dashboard = '/dashboard';
  static const String finanzas = '/finanzas';
  static const String metas = '/metas';
  static const String proyectos = '/proyectos';
  static const String ajustes = '/ajustes';
}

class AppThemes {
  static const Color primaryBlue = Color(0xFF2962FF);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDataLoaded = false;
  
  final formatCurrency = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
  final formatCompact = NumberFormat.compact();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Simulamos la carga de datos
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isDataLoaded = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORACLE Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: !_isDataLoaded 
          ? _buildLoadingState() 
          : Column(
              children: [
                _buildWelcomeCard(),
                
                const SizedBox(height: 16),
                
                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppThemes.primaryBlue.withOpacity(0.2),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    tabs: const [
                      Tab(text: 'Finanzas'),
                      Tab(text: 'Metas'),
                      Tab(text: 'Proyectos'),
                      Tab(text: 'Actividad'),
                    ],
                  ),
                ),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFinancialTab(),
                      _buildGoalsTab(),
                      _buildProjectsTab(),
                      _buildActivityTab(),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Finanzas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Metas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Proyectos',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: AppThemes.primaryBlue,
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppThemes.primaryBlue.withOpacity(0.6),
            const Color(0xFF1A237E).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Text(
              'R',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Rk13termux',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¡Bienvenido de nuevo! Tu día se ve prometedor.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE d MMMM, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).moveY(begin: 15, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen Financiero',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Balance card
          Card(
            color: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppThemes.primaryBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Balance Total',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        formatCurrency.format(1169.50),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(
                    value: 0.52,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(AppThemes.primaryBlue),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Placeholder for charts
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white10,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: const Text('Gráfico de Gastos', style: TextStyle(color: Colors.white)),
          ),
          
          const SizedBox(height: 24),
          
          // Quick actions
          Row(
            children: [
              _buildQuickAction('Ingreso', Icons.trending_up, Colors.green),
              const SizedBox(width: 16),
              _buildQuickAction('Gasto', Icons.trending_down, Colors.red),
              const SizedBox(width: 16),
              _buildQuickAction('Reportes', Icons.assessment, AppThemes.primaryBlue),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGoalsTab() {
    return Center(
      child: Text(
        'Próximamente: Seguimiento de Metas',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }
  
  Widget _buildProjectsTab() {
    return Center(
      child: Text(
        'Próximamente: Gestión de Proyectos',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }
  
  Widget _buildActivityTab() {
    return Center(
      child: Text(
        'Próximamente: Registro de Actividad',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }
}