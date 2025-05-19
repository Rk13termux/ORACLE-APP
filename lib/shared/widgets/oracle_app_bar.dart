import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';

class OracleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double height;

  const OracleAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.height = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo y botón de retroceso
                Row(
                  children: [
                    if (showBackButton && Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    // Logo de ORACLE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppThemes.primaryBlue.withOpacity(0.2),
                        border: Border.all(
                          color: AppThemes.primaryBlue.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        "ORACLE",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Acciones adicionales
                Row(
                  children: actions ?? [],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Título de la pantalla
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}