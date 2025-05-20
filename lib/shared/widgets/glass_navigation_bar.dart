import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/config/routes.dart';

class GlassNavigationBar extends StatelessWidget {
  const GlassNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppThemes.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            icon: Icons.dashboard,
            label: 'Inicio',
            route: AppRouter.dashboard,
            isSelected: true,
          ),
          _buildNavItem(
            context,
            icon: Icons.account_balance_wallet,
            label: 'Finanzas',
            route: AppRouter.finanzas,
          ),
          _buildNavItem(
            context,
            icon: Icons.flag,
            label: 'Metas',
            route: AppRouter.metas,
          ),
          _buildNavItem(
            context,
            icon: Icons.work,
            label: 'Proyectos',
            route: AppRouter.proyectos,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryBlue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppThemes.primaryBlue : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppThemes.primaryBlue : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}