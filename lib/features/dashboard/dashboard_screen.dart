import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/config/routes.dart';
import 'package:vida_organizada/shared/layouts/base_screen_layout.dart';
import 'package:vida_organizada/shared/widgets/glass_navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: 'Dashboard',
      showBackButton: false, // Ocultar botón de retroceso en la pantalla principal
      bottomNavigationBar: const GlassNavigationBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, AppRouter.ajustes),
        ),
      ],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de bienvenida personalizado
            Text(
              'Hola, Rk13termux',
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
            
            // Resumen financiero
            _buildFinancialSummary(),
            
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
              () => Navigator.pushNamed(context, AppRouter.finanzas),
            ),
            
            const SizedBox(height: 12),
            
            // Tarjeta de metas
            _buildMenuCard(
              'Metas',
              'Define y sigue tus objetivos',
              Icons.flag_outlined,
              Colors.orangeAccent, 
              () => Navigator.pushNamed(context, AppRouter.metas),
            ),
            
            const SizedBox(height: 12),
            
            // Tarjeta de proyectos
            _buildMenuCard(
              'Proyectos',
              'Gestiona tus proyectos y tareas',
              Icons.task_alt_outlined,
              Colors.purpleAccent,
              () => Navigator.pushNamed(context, AppRouter.proyectos),
            ),
            
            const SizedBox(height: 12),
            
            // Tarjeta de navegador
            _buildMenuCard(
              'Navegador',
              'Accede a enlaces y contenido web',
              Icons.language_outlined,
              Colors.tealAccent,
              () => Navigator.pushNamed(context, AppRouter.navegador),
            ),
          ],
        ),
      ),
    );
  }
  
  // El resto de los métodos existentes se mantienen igual
  // _buildFinancialSummary(), _buildMenuCard(), etc.

  Widget _buildFinancialSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen financiero',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: AppThemes.glassEffect(
            color: Colors.black,
            opacity: 0.5,
            borderRadius: 20,
            borderColor: AppThemes.primaryBlue.withOpacity(0.3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFinancialItem('Ingresos', '\$2,450.00', Colors.green),
                  _buildFinancialItem('Gastos', '\$1,280.50', Colors.redAccent),
                  _buildFinancialItem('Balance', '\$1,169.50', AppThemes.primaryBlue),
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
        ),
      ],
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
                      style: const TextStyle(
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