import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/config/routes.dart';
import 'package:vida_organizada/features/finanzas/models/transaction_model.dart';
import 'package:vida_organizada/features/finanzas/providers/finance_provider.dart';
import 'package:vida_organizada/shared/layouts/base_screen_layout.dart';
import 'package:vida_organizada/shared/widgets/glass_navigation_bar.dart';
import 'package:vida_organizada/features/dashboard/widgets/metric_card.dart';
import 'package:vida_organizada/features/dashboard/widgets/custom_progress_indicator.dart';
import 'package:vida_organizada/features/dashboard/widgets/activity_timeline_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _isDataLoaded = false;
  
  // Controlador para manejo del desplazamiento
  final ScrollController _scrollController = ScrollController();
  
  // Formateo de moneda y números
  final formatCurrency = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
  final formatCompact = NumberFormat.compact();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
    
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Datos del usuario
    final String username = "Rk13termux";
    final String greeting = _getGreeting();
    
    return BaseScreenLayout(
      title: 'Dashboard Analítico',
      showBackButton: false,
      bottomNavigationBar: const GlassNavigationBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            _showNotificationsPanel(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.pushNamed(context, AppRouter.ajustes),
        ),
      ],
      body: !_isDataLoaded 
          ? _buildLoadingState() 
          : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Encabezado con información del usuario y resumen
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Tarjeta de bienvenida y resumen general
                      _buildWelcomeCard(username, greeting, context),
                      
                      const SizedBox(height: 24),
                      
                      // 2. Métricas clave del usuario
                      _buildKeyMetricsSection(),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .moveY(begin: 15, duration: 400.ms, curve: Curves.easeOutQuad),
                ),
                
                // Pestañas de navegación por categorías
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppThemes.primaryBlue.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppThemes.primaryBlue.withOpacity(0.2),
                          border: Border.all(
                            color: AppThemes.primaryBlue,
                            width: 1,
                          ),
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
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .moveY(begin: 20, duration: 500.ms, curve: Curves.easeOutQuad),
                ),
                
                // Contenido de las pestañas
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // 1. Pestaña de análisis financiero
                      _buildFinancialAnalysisTab(),
                      
                      // 2. Pestaña de seguimiento de metas
                      _buildGoalsAnalysisTab(),
                      
                      // 3. Pestaña de análisis de proyectos
                      _buildProjectsAnalysisTab(),
                      
                      // 4. Pestaña de línea de tiempo de actividad
                      _buildActivityTimelineTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Método para obtener el saludo según la hora del día
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

  // Mostrar panel de notificaciones
  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: AppThemes.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _notificationItem(
                    'Nueva función disponible',
                    'Análisis de gastos por categorías ahora disponible.',
                    Icons.new_releases,
                    Colors.amberAccent,
                    DateTime.now().subtract(const Duration(hours: 1)),
                  ),
                  _notificationItem(
                    'Recordatorio de objetivo',
                    'Tu meta "Ahorrar para vacaciones" vence en 3 días.',
                    Icons.flag,
                    Colors.orangeAccent, 
                    DateTime.now().subtract(const Duration(hours: 5)),
                  ),
                  _notificationItem(
                    'Alerta de presupuesto',
                    'Has alcanzado el 85% de tu presupuesto en Entretenimiento.',
                    Icons.warning_amber,
                    Colors.redAccent,
                    DateTime.now().subtract(const Duration(days: 1)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(
    String title, 
    String message, 
    IconData icon,
    Color color,
    DateTime time,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRelativeTime(time),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppThemes.primaryBlue,
              ),
              backgroundColor: Colors.white10,
              strokeWidth: 6.0,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando datos analíticos...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String username, String greeting, BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM, yyyy');
    final formattedDate = formatter.format(now);
    
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar de usuario
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $username',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Resumen de estado
            const Text(
              'Tu Análisis General',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Indicadores de salud financiera
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _buildGaugeIndicator(
                    title: 'Salud Financiera',
                    value: 0.75,
                    color: Colors.greenAccent,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _buildGaugeIndicator(
                    title: 'Productividad',
                    value: 0.68,
                    color: Colors.amberAccent,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _buildGaugeIndicator(
                    title: 'Progreso Metas',
                    value: 0.52,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaugeIndicator({
    required String title,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CustomProgressIndicator(
            value: value,
            color: color,
            backgroundColor: Colors.white.withOpacity(0.2),
            strokeWidth: 6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Clave',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            MetricCard(
              title: 'Balance Disponible',
              value: formatCurrency.format(1169.50),
              icon: Icons.account_balance_wallet,
              iconColor: Colors.greenAccent,
              trend: '+2.3%',
              trendUp: true,
              onTap: () => Navigator.pushNamed(context, AppRouter.finanzas),
            ).animate().fadeIn(delay: 300.ms),
            
            MetricCard(
              title: 'Metas Completadas',
              value: '4/8',
              icon: Icons.flag_outlined,
              iconColor: Colors.orangeAccent,
              trend: '50%',
              trendUp: true,
              onTap: () => Navigator.pushNamed(context, AppRouter.metas),
            ).animate().fadeIn(delay: 400.ms),
            
            MetricCard(
              title: 'Proyectos Activos',
              value: '3',
              icon: Icons.work_outline,
              iconColor: Colors.purpleAccent,
              trend: '+1',
              trendUp: true,
              onTap: () => Navigator.pushNamed(context, AppRouter.proyectos),
            ).animate().fadeIn(delay: 500.ms),
            
            MetricCard(
              title: 'Tareas Pendientes',
              value: '7',
              icon: Icons.task_alt_outlined,
              iconColor: Colors.blueAccent,
              trend: '-3',
              trendUp: false,
              onTap: () => Navigator.pushNamed(context, AppRouter.proyectos),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ],
    );
  }
  
  // Contenido de la pestaña de análisis financiero
  Widget _buildFinancialAnalysisTab() {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, _) {
        final expensesByCategory = financeProvider.expensesByCategory;
        final totalExpenses = financeProvider.totalExpense;
        
        // Simulamos algunos gastos si no hay datos
        List<PieChartSectionData> pieChartSections = [];
        
        if (expensesByCategory.isEmpty) {
          // Datos simulados para visualización
          final simulatedData = {
            TransactionCategory.food: 350.0,
            TransactionCategory.transport: 180.0,
            TransactionCategory.entertainment: 250.0,
            TransactionCategory.utilities: 420.0,
            TransactionCategory.shopping: 280.0,
          };
          
          int index = 0;
          double total = simulatedData.values.fold(0, (sum, val) => sum + val);
          
          simulatedData.forEach((category, amount) {
            final transaction = Transaction(
              id: '0',
              title: '',
              amount: 0,
              date: DateTime.now(),
              type: TransactionType.expense,
              category: category,
            );
            
            pieChartSections.add(PieChartSectionData(
              value: amount,
              title: '${((amount / total) * 100).toStringAsFixed(1)}%',
              color: transaction.categoryColor,
              radius: index == 0 ? 60 : 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
              badgeWidget: Icon(
                transaction.categoryIcon,
                color: Colors.white,
                size: 16,
              ),
              badgePositionPercentageOffset: 1.1,
            ));
            index++;
          });
        } else {
          int index = 0;
          expensesByCategory.forEach((category, amount) {
            final transaction = Transaction(
              id: '0',
              title: '',
              amount: 0,
              date: DateTime.now(),
              type: TransactionType.expense,
              category: category,
            );
            
            pieChartSections.add(PieChartSectionData(
              value: amount,
              title: '${((amount / totalExpenses) * 100).toStringAsFixed(1)}%',
              color: transaction.categoryColor,
              radius: index == 0 ? 60 : 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
              badgeWidget: Icon(
                transaction.categoryIcon,
                color: Colors.white,
                size: 16,
              ),
              badgePositionPercentageOffset: 1.1,
            ));
            index++;
          });
        }
        
        // Datos para el gráfico de barras de ingresos vs gastos
        final List<Map<String, dynamic>> monthlyFinanceData = [
          {'month': 'Ene', 'income': 1800.0, 'expense': 1250.0},
          {'month': 'Feb', 'income': 2100.0, 'expense': 1450.0},
          {'month': 'Mar', 'income': 1950.0, 'expense': 1600.0},
          {'month': 'Abr', 'income': 2300.0, 'expense': 1800.0},
          {'month': 'May', 'income': 2450.0, 'expense': 1280.5},
        ];
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen financiero
                _buildFinancialSummary(financeProvider),
                
                const SizedBox(height: 30),
                
                // Gráfico de gastos por categoría
                Text(
                  'Análisis de Gastos por Categoría',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Aquí se podría implementar interactividad al tocar el gráfico
                        },
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: pieChartSections,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Leyenda de categorías
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: _buildLegendItems(expensesByCategory.isEmpty 
                      ? {
                          TransactionCategory.food: 350.0,
                          TransactionCategory.transport: 180.0,
                          TransactionCategory.entertainment: 250.0,
                          TransactionCategory.utilities: 420.0,
                          TransactionCategory.shopping: 280.0,
                        }
                      : expensesByCategory),
                ),
                
                const SizedBox(height: 32),
                
                // Gráfico de ingresos vs gastos por mes
                Text(
                  'Ingresos vs Gastos (Últimos 5 meses)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 220,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.compact(),
                      labelStyle: const TextStyle(color: Colors.white70),
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(width: 0),
                    ),
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      textStyle: TextStyle(color: Colors.white70),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<Map<String, dynamic>, String>>[
                      ColumnSeries<Map<String, dynamic>, String>(
                        name: 'Ingresos',
                        dataSource: monthlyFinanceData,
                        xValueMapper: (Map<String, dynamic> data, _) => data['month'],
                        yValueMapper: (Map<String, dynamic> data, _) => data['income'],
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      ColumnSeries<Map<String, dynamic>, String>(
                        name: 'Gastos',
                        dataSource: monthlyFinanceData,
                        xValueMapper: (Map<String, dynamic> data, _) => data['month'],
                        yValueMapper: (Map<String, dynamic> data, _) => data['expense'],
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Tendencia de ahorro
                Text(
                  'Tendencia de Ahorros',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 220,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.compact(),
                      labelStyle: const TextStyle(color: Colors.white70),
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(width: 0),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<Map<String, dynamic>, String>>[
                      LineSeries<Map<String, dynamic>, String>(
                        name: 'Ahorros',
                        dataSource: monthlyFinanceData,
                        xValueMapper: (Map<String, dynamic> data, _) => data['month'],
                        yValueMapper: (Map<String, dynamic> data, _) => 
                            data['income'] - data['expense'],
                        color: AppThemes.primaryBlue,
                        width: 3,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          height: 8,
                          width: 8,
                        ),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.top,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      AreaSeries<Map<String, dynamic>, String>(
                        name: 'Área',
                        dataSource: monthlyFinanceData,
                        xValueMapper: (Map<String, dynamic> data, _) => data['month'],
                        yValueMapper: (Map<String, dynamic> data, _) => 
                            data['income'] - data['expense'],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppThemes.primaryBlue.withOpacity(0.4),
                            AppThemes.primaryBlue.withOpacity(0.0),
                          ],
                        ),
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Acciones rápidas para finanzas
                _buildQuickActions(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildLegendItems(Map<TransactionCategory, double> data) {
    return data.entries.map((entry) {
      final transaction = Transaction(
        id: '0',
        title: '',
        amount: 0,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: entry.key,
      );
      
      // Convertir nombre de enum a texto presentable
      String categoryName = entry.key.toString().split('.').last;
      categoryName = categoryName[0].toUpperCase() + categoryName.substring(1);
      
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            transaction.categoryIcon,
            color: transaction.categoryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$categoryName: ${formatCurrency.format(entry.value)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildFinancialSummary(FinanceProvider provider) {
    final balance = provider.balance > 0 ? provider.balance : 1169.50;
    final income = provider.totalIncome > 0 ? provider.totalIncome : 2450.0;
    final expense = provider.totalExpense > 0 ? provider.totalExpense : 1280.5;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppThemes.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance Total',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency.format(balance),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.greenAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+8.2% este mes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFinancialItem(
                'Ingresos', 
                formatCurrency.format(income),
                Colors.green
              ),
              _buildFinancialItem(
                'Gastos', 
                formatCurrency.format(expense),
                Colors.red
              ),
              _buildFinancialItem(
                'Ahorro', 
                '${(balance > 0 ? balance / income * 100 : 0).toStringAsFixed(0)}%',
                AppThemes.primaryBlue
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.52,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(AppThemes.primaryBlue),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '52% del presupuesto utilizado',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                '12 días restantes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFinancialItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildActionButton(
              'Nuevo\nIngreso', 
              Icons.trending_up, 
              Colors.greenAccent,
              () {
                // Acción para añadir ingreso
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Nuevo\nGasto', 
              Icons.trending_down, 
              Colors.redAccent,
              () {
                // Acción para añadir gasto
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Ver\nReportes', 
              Icons.assessment, 
              Colors.blueAccent,
              () {
                // Acción para ver reportes
              },
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Establecer\nPresupuesto', 
              Icons.account_balance, 
              Colors.purpleAccent,
              () {
                // Acción para establecer presupuesto
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Contenido de la pestaña de análisis de metas
  Widget _buildGoalsAnalysisTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de metas
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.withOpacity(0.6),
                    Colors.deepPurple.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total de Metas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '8',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Completadas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '4',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progreso General',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '50%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // Título del gráfico de categorías
            Text(
              'Progreso por Categorías',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // En lugar del gráfico radar, usamos un conjunto de barras de progreso
            _buildCategoryProgressBars(),
            
            const SizedBox(height: 30),
            
            Text(
              'Tus Metas en Progreso',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            _buildGoalsList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryProgressBars() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Finanzas', 'progress': 0.45, 'color': Colors.blueAccent},
      {'name': 'Salud', 'progress': 0.7, 'color': Colors.greenAccent},
      {'name': 'Carrera', 'progress': 0.6, 'color': Colors.orangeAccent},
      {'name': 'Personal', 'progress': 0.5, 'color': Colors.purpleAccent},
      {'name': 'Familia', 'progress': 0.3, 'color': Colors.pinkAccent},
    ];
    
    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${(category['progress'] * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: category['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: category['progress'],
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildGoalsList() {
    final List<Map<String, dynamic>> goalsData = [
      {
        'title': 'Ahorrar para vacaciones',
        'category': 'Finanzas',
        'progress': 0.65,
        'target': 2000.0,
        'current': 1300.0,
        'dueDate': DateTime(2025, 8, 15),
        'iconData': Icons.beach_access,
        'color': Colors.orangeAccent,
      },
      {
        'title': 'Leer 12 libros',
        'category': 'Personal',
        'progress': 0.5,
        'target': 12,
        'current': 6,
        'dueDate': DateTime(2025, 12, 31),
        'iconData': Icons.book,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Ejercicio semanal',
        'category': 'Salud',
        'progress': 0.7,
        'target': 5,
        'current': 3.5,
        'dueDate': DateTime(2025, 5, 26),
        'iconData': Icons.fitness_center,
        'color': Colors.greenAccent,
      },
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goalsData.length,
      itemBuilder: (context, index) {
        final goal = goalsData[index];
        final remainingDays = goal['dueDate'].difference(DateTime.now()).inDays;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: goal['color'].withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: goal['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        goal['iconData'] as IconData,
                        color: goal['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: goal['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: goal['color'].withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  goal['category'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: goal['color'],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$remainingDays días restantes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(goal['progress'] * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: goal['color'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: goal['progress'],
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(goal['color']),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal['category'] == 'Finanzas'
                          ? '${formatCurrency.format(goal['current'])} de ${formatCurrency.format(goal['target'])}'
                          : '${goal['current']} de ${goal['target']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Acción para actualizar progreso
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: goal['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.update,
                              color: goal['color'],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Actualizar',
                              style: TextStyle(
                                color: goal['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Pestaña de análisis de proyectos
  Widget _buildProjectsAnalysisTab() {
    // Datos de ejemplo para proyectos
    final List<Map<String, dynamic>> projectsData = [
      {
        'title': 'Rediseño de App',
        'progress': 0.7,
        'tasks': 12,
        'completed': 8,
        'color': Colors.blueAccent,
        'dueDate': DateTime(2025, 6, 10),
        'team': ['Alex', 'María', 'Juan'],
      },
      {
        'title': 'Planificación Financiera 2025',
        'progress': 0.4,
        'tasks': 8,
        'completed': 3,
        'color': Colors.greenAccent,
        'dueDate': DateTime(2025, 5, 30),
        'team': ['Sofía', 'Pedro'],
      },
      {
        'title': 'Curso de Flutter Avanzado',
        'progress': 0.6,
        'tasks': 10,
        'completed': 6,
        'color': Colors.purpleAccent,
        'dueDate': DateTime(2025, 7, 15),
        'team': ['Rk13termux'],
      },
    ];
    
    return SingleScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de proyectos
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueAccent.withOpacity(0.6),
                    Colors.deepPurple.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de Proyectos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProjectMetric(
                        value: '3',
                        label: 'Activos',
                        color: Colors.blueAccent,
                        icon: Icons.play_circle_outline,
                      ),
                      _buildProjectMetric(
                        value: '58%',
                        label: 'Completado',
                        color: Colors.greenAccent,
                        icon: Icons.check_circle_outline,
                      ),
                      _buildProjectMetric(
                        value: '32',
                        label: 'Tareas',
                        color: Colors.amberAccent,
                        icon: Icons.task_alt,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Proyectos activos
            Text(
              'Proyectos Activos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Lista de proyectos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projectsData.length,
              itemBuilder: (context, index) {
                final project = projectsData[index];
                return _buildProjectCard(project);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProjectCard(Map<String, dynamic> project) {
    final remainingDays = project['dueDate'].difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: project['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(project['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: project['color'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: project['progress'],
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(project['color']),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              _buildProjectInfoItem(
                icon: Icons.task_alt,
                label: 'Tareas',
                value: '${project['completed']}/${project['tasks']}',
              ),
              _buildProjectInfoItem(
                icon: Icons.
                  // Método _buildProjectMetric que faltaba
  Widget _buildProjectMetric({
    required String value, 
    required String label, 
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  // Método _buildProjectInfoItem que faltaba
  Widget _buildProjectInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Método _buildActivityTimelineTab que faltaba
  Widget _buildActivityTimelineTab() {
    // Datos de ejemplo para la línea de tiempo
    final List<Map<String, dynamic>> activityData = [
      {
        'title': 'Reporte financiero generado',
        'type': 'Finanzas',
        'icon': Icons.assessment,
        'color': Colors.blueAccent,
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
      },
      {
        'title': 'Meta "Ahorrar para vacaciones" actualizada',
        'type': 'Metas',
        'icon': Icons.flag,
        'color': Colors.orangeAccent,
        'time': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'title': 'Nueva tarea añadida a "Rediseño de App"',
        'type': 'Proyectos',
        'icon': Icons.task_alt,
        'color': Colors.purpleAccent,
        'time': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'title': 'Gastos por categoría analizados',
        'type': 'Finanzas',
        'icon': Icons.pie_chart,
        'color': Colors.blueAccent,
        'time': DateTime.now().subtract(const Duration(hours: 8)),
      },
      {
        'title': 'Meta "Ejercicio semanal" completada',
        'type': 'Metas',
        'icon': Icons.fitness_center,
        'color': Colors.orangeAccent,
        'time': DateTime.now().subtract(const Duration(hours: 12)),
      },
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppThemes.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tu línea de tiempo muestra toda tu actividad reciente en orden cronológico',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: activityData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay actividad reciente',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: activityData.length,
                    itemBuilder: (context, index) {
                      final activity = activityData[index];
                      
                      return ActivityTimelineItem(
                        title: activity['title'],
                        type: activity['type'],
                        icon: activity['icon'],
                        color: activity['color'],
                        time: activity['time'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Corrección del método _buildProjectsAnalysisTab
  Widget _buildProjectsAnalysisTab() {
    // Datos de ejemplo para proyectos
    final List<Map<String, dynamic>> projectsData = [
      {
        'title': 'Rediseño de App',
        'progress': 0.7,
        'tasks': 12,
        'completed': 8,
        'color': Colors.blueAccent,
        'dueDate': DateTime(2025, 6, 10),
        'team': ['Alex', 'María', 'Juan'],
      },
      {
        'title': 'Planificación Financiera 2025',
        'progress': 0.4,
        'tasks': 8,
        'completed': 3,
        'color': Colors.greenAccent,
        'dueDate': DateTime(2025, 5, 30),
        'team': ['Sofía', 'Pedro'],
      },
      {
        'title': 'Curso de Flutter Avanzado',
        'progress': 0.6,
        'tasks': 10,
        'completed': 6,
        'color': Colors.purpleAccent,
        'dueDate': DateTime(2025, 7, 15),
        'team': ['Rk13termux'],
      },
    ];
    
    return SingleChildScrollView( // Corregido a SingleChildScrollView en lugar de SingleScrollView
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de proyectos
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueAccent.withOpacity(0.6),
                    Colors.deepPurple.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de Proyectos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProjectMetric(
                        value: '3',
                        label: 'Activos',
                        color: Colors.blueAccent,
                        icon: Icons.play_circle_outline,
                      ),
                      _buildProjectMetric(
                        value: '58%',
                        label: 'Completado',
                        color: Colors.greenAccent,
                        icon: Icons.check_circle_outline,
                      ),
                      _buildProjectMetric(
                        value: '32',
                        label: 'Tareas',
                        color: Colors.amberAccent,
                        icon: Icons.task_alt,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Proyectos activos
            Text(
              'Proyectos Activos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Lista de proyectos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projectsData.length,
              itemBuilder: (context, index) {
                final project = projectsData[index];
                return _buildProjectCard(project);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Corrección de la implementación de _buildProjectCard
  Widget _buildProjectCard(Map<String, dynamic> project) {
    final remainingDays = project['dueDate'].difference(DateTime.now()).inDays;
    final formatter = DateFormat('dd/MM/yyyy');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: project['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(project['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: project['color'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: project['progress'],
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(project['color']),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              _buildProjectInfoItem(
                icon: Icons.task_alt,
                label: 'Tareas',
                value: '${project['completed']}/${project['tasks']}',
              ),
              _buildProjectInfoItem(
                icon: Icons.calendar_today,
                label: 'Fecha límite',
                value: formatter.format(project['dueDate']),
              ),
              _buildProjectInfoItem(
                icon: Icons.timelapse,
                label: 'Restante',
                value: '$remainingDays días',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              const Text(
                'Equipo:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: (project['team'] as List).map((member) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: project['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: project['color'].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        member,
                        style: TextStyle(
                          fontSize: 12,
                          color: project['color'],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }