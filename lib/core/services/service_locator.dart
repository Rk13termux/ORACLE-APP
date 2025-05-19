import 'package:get_it/get_it.dart';
import 'package:vida_organizada/core/database/database_service.dart';
import 'package:vida_organizada/core/services/auth_service.dart';
import 'package:vida_organizada/core/services/storage_service.dart';
import 'package:vida_organizada/core/services/navigation_service.dart';
import 'package:vida_organizada/core/services/analytics_service.dart';

class ServiceLocator {
  static final GetIt _locator = GetIt.instance;

  static T get<T extends Object>() => _locator.get<T>();

  static bool isRegistered<T extends Object>() => _locator.isRegistered<T>();

  static void registerSingleton<T extends Object>(T instance) {
    if (!isRegistered<T>()) {
      _locator.registerSingleton<T>(instance);
    }
  }

  static void registerLazySingleton<T extends Object>(
      T Function() factoryFunc) {
    if (!isRegistered<T>()) {
      _locator.registerLazySingleton<T>(factoryFunc);
    }
  }
}

Future<void> setupServiceLocator() async {
  // Registrar servicios como singletons
  ServiceLocator.registerLazySingleton<NavigationService>(
    () => NavigationService(),
  );
  
  ServiceLocator.registerLazySingleton<StorageService>(
    () => StorageService(),
  );
  
  ServiceLocator.registerLazySingleton<DatabaseService>(
    () => DatabaseService(),
  );
  
  ServiceLocator.registerLazySingleton<AuthService>(
    () => AuthService(),
  );
  
  ServiceLocator.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(),
  );
}