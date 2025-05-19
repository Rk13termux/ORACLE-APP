import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vida_organizada/config/routes.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/features/finanzas/providers/finance_provider.dart';

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
  
  // Registrar adaptadores de Hive según sea necesario
  // Agrega los registerAdapter cuando implementes tus modelos
  // Por ejemplo: Hive.registerAdapter(TransactionAdapter());
  
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
        // Providers de la aplicación
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
        // Añade más providers según sea necesario
      ],
      child: const OracleApp(),
    );
  }
}

class OracleApp extends StatelessWidget {
  const OracleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORACLE APP',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      initialRoute: AppRouter.dashboard,
      onGenerateRoute: AppRouter.generateRoute,
      // Se ha eliminado la línea 'home:' que era redundante con 'initialRoute'
    );
  }
}