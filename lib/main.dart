import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';

import 'config/themes.dart';
import 'features/dashboard/dashboard_screen.dart';

// Modelos de datos para metas y seguimiento
part 'models/goal_model.dart';
part 'models/task_model.dart';
part 'models/check_in_model.dart';
part 'models/goal_category.dart';
part 'providers/goals_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuramos la orientación de la pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configuramos la superposición del sistema UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppThemes.primaryBlack,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Inicializamos Hive para la persistencia de datos
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Registramos los adaptadores para nuestros modelos
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(CheckInModelAdapter());
  Hive.registerAdapter(GoalCategoryAdapter());

  // Abrimos las cajas (boxes) para cada modelo
  await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<TaskModel>('tasks');
  await Hive.openBox<CheckInModel>('checkIns');

  runApp(const OracleApp());
}

class OracleApp extends StatelessWidget {
  const OracleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ORACLE',
        theme: AppThemes.darkTheme,
        home: const OracleHomePage(),
      ),
    );
  }
}

class OracleHomePage extends StatefulWidget {
  const OracleHomePage({Key? key}) : super(key: key);

  @override
  State<OracleHomePage> createState() => _OracleHomePageState();
}

class _OracleHomePageState extends State<OracleHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1; // Comenzamos en la pestaña de Metas
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Simulamos una carga de datos
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    
    // Precargar datos de ejemplo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
      if (goalsProvider.goals.isEmpty) {
        goalsProvider.loadSampleGoals();
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
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        title: const Text(
          'ORACLE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications(context);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.deepBlack.withOpacity(0.9),
              AppThemes.primaryBlack,
              Color.lerp(AppThemes.primaryBlack, AppThemes.primaryBlue.withOpacity(0.2), 0.1)!,
            ],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/grid_pattern.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.05,
          ),
        ),
        child: _isLoading ? _buildLoadingScreen() : _buildMainContent(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _selectedIndex == 1 ? _buildFloatingActionButton() : null,
    );
  }
  
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppThemes.glassBlack,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppThemes.primaryBlue.withOpacity(0.7),
                  AppThemes.secondaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Text(
                    'R',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Rk13termux',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Usuario Premium',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 0);
          }),
          _buildDrawerItem(Icons.flag_rounded, 'Metas', () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 1);
          }),
          _buildDrawerItem(Icons.insert_chart_outlined, 'Estadísticas', () {
            Navigator.pop(context);
            _showComingSoonSnackbar('Estadísticas');
          }),
          _buildDrawerItem(Icons.settings, 'Configuración', () {
            Navigator.pop(context);
            _showComingSoonSnackbar('Configuración');
          }),
          const Divider(color: Colors.white24),
          _buildDrawerItem(Icons.help_outline, 'Ayuda', () {
            Navigator.pop(context);
            _showComingSoonSnackbar('Ayuda');
          }),
          _buildDrawerItem(Icons.info_outline, 'Acerca de', () {
            Navigator.pop(context);
            _showAboutDialog();
          }),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppThemes.neonBlue),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando tus metas...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return _buildGoalsScreen();
      default:
        return const Center(child: Text('Página no encontrada'));
    }
  }

  Widget _buildGoalsScreen() {
    return Consumer<GoalsProvider>(
      builder: (context, goalsProvider, child) {
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 60),
            // Tabs para alternar entre vistas
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppThemes.primaryBlue.withOpacity(0.2),
                  border: Border.all(
                    color: AppThemes.primaryBlue,
                    width: 1,
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: 'Lista de Metas'),
                  Tab(text: 'Calendario'),
                ],
              ),
            ),
            // Contenido de las pestañas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGoalsListTab(goalsProvider),
                  _buildCalendarTab(goalsProvider),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalsListTab(GoalsProvider goalsProvider) {
    if (goalsProvider.goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay metas configuradas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pulsa el botón + para crear una nueva meta',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    // Agrupar metas por categoría
    final Map<GoalCategory, List<GoalModel>> goalsByCategory = {};
    for (var goal in goalsProvider.goals) {
      if (!goalsByCategory.containsKey(goal.category)) {
        goalsByCategory[goal.category] = [];
      }
      goalsByCategory[goal.category]!.add(goal);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Text(
                'Mis Metas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _buildProgressIndicator(goalsProvider.overallProgress),
              const SizedBox(width: 8),
              Text(
                '${(goalsProvider.overallProgress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        ...goalsByCategory.entries.map((entry) => _buildCategorySection(entry.key, entry.value, goalsProvider)).toList(),
      ],
    );
  }

  Widget _buildCategorySection(GoalCategory category, List<GoalModel> goals, GoalsProvider goalsProvider) {
    final double categoryProgress = goals.isEmpty
        ? 0
        : goals.fold(0.0, (sum, goal) => sum + goal.progress) / goals.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(
                category.icon,
                color: category.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
              ),
              const Spacer(),
              Text(
                '${(categoryProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
              ),
            ],
          ),
        ),
        ...goals.map((goal) => _buildGoalCard(goal, goalsProvider)).toList(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGoalCard(GoalModel goal, GoalsProvider goalsProvider) {
    final daysLeft = goal.dueDate.difference(DateTime.now()).inDays;
    final Color statusColor = goal.progress >= 1.0 
        ? Colors.green
        : daysLeft < 0
            ? Colors.red
            : daysLeft < 3
                ? Colors.orange
                : goal.category.color;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGoalDetailsDialog(goal, goalsProvider),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: goal.category.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        goal.icon,
                        color: goal.category.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            goal.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Barra de progreso
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Información adicional
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Progreso numérico
                    Row(
                      children: [
                        const Icon(Icons.checklist, size: 16, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(
                          goal.progressText,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    
                    // Fecha límite
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(
                          daysLeft < 0
                              ? 'Vencida'
                              : daysLeft == 0
                                  ? 'Hoy'
                                  : '$daysLeft días',
                          style: TextStyle(
                            fontSize: 14,
                            color: daysLeft < 0 ? Colors.red : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    
                    // Porcentaje de progreso
                    Text(
                      '${(goal.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).moveY(begin: 10, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildCalendarTab(GoalsProvider goalsProvider) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 3, 1);
    final lastDay = DateTime(now.year, now.month + 3, 0);
    
    // Crear un mapa de fechas con eventos (metas por fecha)
    Map<DateTime, List<GoalModel>> goalsByDate = {};
    for (var goal in goalsProvider.goals) {
      // Añadir fecha de inicio
      final startDateKey = DateTime(goal.startDate.year, goal.startDate.month, goal.startDate.day);
      if (!goalsByDate.containsKey(startDateKey)) {
        goalsByDate[startDateKey] = [];
      }
      goalsByDate[startDateKey]!.add(goal);
      
      // Añadir fecha de vencimiento
      final dueDateKey = DateTime(goal.dueDate.year, goal.dueDate.month, goal.dueDate.day);
      if (!goalsByDate.containsKey(dueDateKey)) {
        goalsByDate[dueDateKey] = [];
      }
      goalsByDate[dueDateKey]!.add(goal);
    }
    
    return Column(
      children: [
        // Calendario
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: now,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white70),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white70),
              headerPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white70),
              weekendStyle: TextStyle(color: Colors.white38),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.white70),
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(
                color: AppThemes.primaryBlue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppThemes.primaryBlue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppThemes.primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
            eventLoader: (day) {
              final normalizedDate = DateTime(day.year, day.month, day.day);
              return goalsByDate[normalizedDate] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              _showDayEventsDialog(selectedDay, goalsByDate, goalsProvider);
            },
          ),
        ),
        
        // Lista de metas próximas
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.upcoming, color: Colors.white70),
              const SizedBox(width: 8),
              const Text(
                'Próximas fechas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Lista de metas próximas
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _getUpcomingGoals(goalsProvider).map((goal) {
              final daysLeft = goal.dueDate.difference(DateTime.now()).inDays;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.black26,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: goal.category.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    goal.icon,
                    color: goal.category.color,
                    size: 20,
                  ),
                ),
                title: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  daysLeft == 0
                      ? 'Vence hoy'
                      : 'Vence en $daysLeft días',
                  style: TextStyle(
                    color: daysLeft <= 2 ? Colors.orange : Colors.white70,
                  ),
                ),
                trailing: CircularProgressIndicator(
                  value: goal.progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(goal.category.color),
                ),
                onTap: () => _showGoalDetailsDialog(goal, goalsProvider),
              ).animate().fadeIn(delay: 200.ms);
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  List<GoalModel> _getUpcomingGoals(GoalsProvider goalsProvider) {
    final now = DateTime.now();
    final twoWeeksFromNow = now.add(const Duration(days: 14));
    
    return goalsProvider.goals
        .where((goal) => 
            goal.dueDate.isAfter(now) && 
            goal.dueDate.isBefore(twoWeeksFromNow) &&
            goal.progress < 1.0)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: AppThemes.primaryBlue.withOpacity(0.3),
        height: 64,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.flag, color: Colors.white),
            label: 'Metas',
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showAddGoalDialog(context),
      backgroundColor: AppThemes.primaryBlue,
      child: const Icon(Icons.add, color: Colors.white),
    ).animate().scale(duration: 300.ms, curve: Curves.elasticOut);
  }
  
  void _showSearchDialog(BuildContext context) {
    // Implementación del diálogo de búsqueda
    _showComingSoonSnackbar('Búsqueda avanzada');
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppThemes.glassBlack,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Text(
                      'Notificaciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              Expanded(
                child: _notificationsList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationsList() {
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    final upcomingGoals = _getUpcomingGoals(goalsProvider);
    
    if (upcomingGoals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 48,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay notificaciones',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: upcomingGoals.length,
      itemBuilder: (context, index) {
        final goal = upcomingGoals[index];
        final daysLeft = goal.dueDate.difference(DateTime.now()).inDays;
        
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: goal.category.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.alarm, color: goal.category.color),
          ),
          title: Text(
            'Meta próxima a vencer',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            '${goal.title} - ${daysLeft == 0 ? 'Hoy' : 'En $daysLeft días'}',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          trailing: Text(
            '${(goal.progress * 100).toInt()}%',
            style: TextStyle(
              color: goal.category.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            _showGoalDetailsDialog(goal, goalsProvider);
          },
        );
      },
    );
  }

  void _showComingSoonSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'ORACLE App',
      applicationVersion: 'v2.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppThemes.primaryBlue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.insights,
          color: AppThemes.primaryBlue,
          size: 24,
        ),
      ),
      children: [
        Text(
          'ORACLE es un sistema completo para organización, planificación y seguimiento de metas y hábitos personales.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(height: 16),
        Text(
          '© ${DateTime.now().year} Rk13termux',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    GoalCategory category = GoalCategory.personal;
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    int targetValue = 1;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: AppThemes.glassBlack,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.add_task, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'Nueva Meta',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Título
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Título',
                              icon: Icon(Icons.title),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor introduce un título';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Descripción
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                              icon: Icon(Icons.description),
                            ),
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            onChanged: (value) {
                              description = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Categoría
                          Row(
                            children: [
                              const Icon(Icons.category, color: Colors.white54),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<GoalCategory>(
                                  decoration: const InputDecoration(
                                    labelText: 'Categoría',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: category,
                                  items: GoalCategory.values.map((cat) {
                                    return DropdownMenuItem<GoalCategory>(
                                      value: cat,
                                      child: Row(
                                        children: [
                                          Icon(cat.icon, color: cat.color, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            cat.name,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      category = newValue!;
                                    });
                                  },
                                  dropdownColor: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Fecha límite
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white54),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: dueDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (picked != null && picked != dueDate) {
                                      setState(() {
                                        dueDate = picked;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'Fecha límite: ${DateFormat('dd/MM/yyyy').format(dueDate)}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Objetivo numérico
                          Row(
                            children: [
                              const Icon(Icons.flag, color: Colors.white54),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Valor objetivo',
                                    hintText: 'Ej: 10 libros, 5 km, etc.',
                                  ),
                                  initialValue: '1',
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor introduce un valor';
                                    }
                                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                                      return 'Introduce un número válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (int.tryParse(value) != null) {
                                      targetValue = int.parse(value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Botones de acción
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Crear nueva meta
                                final goal = GoalModel(
                                  id: const Uuid().v4(),
                                  title: title,
                                  description: description,
                                  category: category,
                                  startDate: DateTime.now(),
                                  dueDate: dueDate,
                                  targetValue: targetValue,
                                  currentValue: 0,
                                );
                                
                                // Añadir la meta
                                Provider.of<GoalsProvider>(context, listen: false).addGoal(goal);
                                
                                Navigator.pop(context);
                                
                                // Mostrar confirmación
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Meta creada con éxito'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
  
  void _showGoalDetailsDialog(GoalModel goal, GoalsProvider goalsProvider) {
    final daysLeft = goal.dueDate.difference(DateTime.now()).inDays;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: AppThemes.glassBlack,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado con título
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          goal.category.color.withOpacity(0.8),
                          goal.category.color.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            goal.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                goal.category.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Descripción
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goal.description.isEmpty ? 'Sin descripción' : goal.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Progreso
                        const Text(
                          'Progreso',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: [
                                  CircularProgressIndicator(
                                    value: goal.progress,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.white12,
                                    valueColor: AlwaysStoppedAnimation<Color>(goal.category.color),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${(goal.progress * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: goal.category.color,
                                          ),
                                        ),
                                        Text(
                                          '${goal.currentValue}/${goal.targetValue}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Fechas
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white10,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDateColumn('Inicio', goal.startDate),
                              Container(height: 40, width: 1, color: Colors.white24),
                              _buildDateColumn('Vencimiento', goal.dueDate, isExpired: daysLeft < 0),
                              Container(height: 40, width: 1, color: Colors.white24),
                              _buildDateColumn('Días restantes', null, daysLeft: daysLeft),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Actualizar progreso
                        const Text(
                          'Actualizar progreso',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Botón de decremento
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.white70,
                              onPressed: goal.currentValue > 0
                                  ? () {
                                      setState(() {
                                        goalsProvider.updateGoalProgress(
                                          goal.id,
                                          goal.currentValue - 1,
                                        );
                                      });
                                    }
                                  : null,
                            ),
                            
                            // Barra de progreso
                            Expanded(
                              child: Slider(
                                value: goal.currentValue.toDouble(),
                                min: 0,
                                max: goal.targetValue.toDouble(),
                                divisions: goal.targetValue,
                                label: goal.currentValue.toString(),
                                activeColor: goal.category.color,
                                inactiveColor: Colors.white24,
                                onChanged: (value) {
                                  setState(() {
                                    goalsProvider.updateGoalProgress(
                                      goal.id,
                                      value.toInt(),
                                    );
                                  });
                                },
                              ),
                            ),
                            
                            // Botón de incremento
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: goal.currentValue < goal.targetValue ? Colors.white70 : Colors.white24,
                              onPressed: goal.currentValue < goal.targetValue
                                  ? () {
                                      setState(() {
                                        goalsProvider.updateGoalProgress(
                                          goal.id,
                                          goal.currentValue + 1,
                                        );
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Botón de completar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Marcar como completada'),
                            onPressed: goal.progress < 1.0
                                ? () {
                                    goalsProvider.updateGoalProgress(
                                      goal.id,
                                      goal.targetValue,
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('¡Meta completada! ¡Felicidades!'),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              disabledBackgroundColor: Colors.grey.shade800,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Historial de seguimiento
                        const Text(
                          'Historial de seguimiento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Mostrar historial de check-ins
                        ...goal.checkIns.map((checkIn) => _buildCheckInItem(checkIn)).toList(),
                        
                        if (goal.checkIns.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No hay registros de seguimiento',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  
                  // Botones de acción en la parte inferior
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón de eliminar
                        TextButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteConfirmationDialog(goal.id);
                          },
                        ),
                        
                        // Botón de registrar progreso
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add_task),
                          label: const Text('Registrar avance'),
                          onPressed: () {
                            _showCheckInDialog(goal, goalsProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
  
  Widget _buildDateColumn(String label, DateTime? date, {bool isExpired = false, int? daysLeft}) {
    final formattedDate = date != null ? DateFormat('dd/MM/yyyy').format(date) : '-';
    
    String daysText = '';
    Color textColor = Colors.white;
    
    if (daysLeft != null) {
      if (daysLeft < 0) {
        daysText = 'Expirada';
        textColor = Colors.red;
      } else if (daysLeft == 0) {
        daysText = 'Hoy';
        textColor = Colors.orange;
      } else {
        daysText = '$daysLeft días';
        textColor = daysLeft <= 3 ? Colors.orange : Colors.white;
      }
    }
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          daysLeft != null ? daysText : formattedDate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isExpired ? Colors.red : textColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCheckInItem(CheckInModel checkIn) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppThemes.primaryBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.check_circle_outline,
            color: AppThemes.primaryBlue,
          ),
        ),
      ),
      title: Text(
        'Progreso actualizado a ${checkIn.newValue}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy HH:mm').format(checkIn.date),
        style: TextStyle(
          fontSize: 13,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppThemes.primaryBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '+${checkIn.increment}',
          style: const TextStyle(
            color: AppThemes.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  void _showCheckInDialog(GoalModel goal, GoalsProvider goalsProvider) {
    int incrementValue = 1;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar avance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Registra tu avance en esta meta:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: incrementValue > 1
                        ? () => setState(() => incrementValue--)
                        : null,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: incrementValue.toString(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Incremento',
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (int.tryParse(value) != null) {
                          incrementValue = int.parse(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => incrementValue++),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Progreso actual: ${goal.currentValue}/${goal.targetValue}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Nuevo progreso: ${math.min(goal.currentValue + incrementValue, goal.targetValue)}/${goal.targetValue}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newValue = math.min(goal.currentValue + incrementValue, goal.targetValue);
                goalsProvider.addCheckIn(
                  goal.id,
                  newValue,
                  incrementValue,
                );
                Navigator.pop(context);

                // Si la meta se ha completado, mostrar mensaje de felicitación
                if (newValue >= goal.targetValue) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Meta completada! ¡Felicidades!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Progreso registrado correctamente'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteConfirmationDialog(String goalId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Meta'),
          content: const Text('¿Estás seguro de que quieres eliminar esta meta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: ()