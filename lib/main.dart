import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vida_organizada/app.dart';
import 'package:vida_organizada/core/database/database_service.dart';
import 'package:vida_organizada/core/services/service_locator.dart';

void main() async {
  // Asegurar que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación de pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializar Hive para almacenamiento local
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  
  // Registrar adaptadores de Hive
  // Aquí se registrarán los modelos de datos personalizados
  
  // Inicializar el localizador de servicios
  await setupServiceLocator();
  
  // Inicializar la base de datos
  await ServiceLocator.get<DatabaseService>().initialize();
  
  // Establecer el estilo de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const AppProviders());
}

class AppProviders extends StatelessWidget {
  const AppProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Aquí irán los diferentes providers de la aplicación
        // Como ejemplos:
        // ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => FinanzasProvider()),
        // ChangeNotifierProvider(create: (_) => MetasProvider()),
        // ChangeNotifierProvider(create: (_) => ProyectosProvider()),
      ],
      child: const VidaOrganizadaApp(),
    );
  }
}