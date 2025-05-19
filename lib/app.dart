import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vida_organizada/config/routes.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/features/dashboard/dashboard_screen.dart';

class VidaOrganizadaApp extends StatelessWidget {
  const VidaOrganizadaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vida Organizada',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const DashboardScreen(),
    );
  }
}