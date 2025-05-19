class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    // Implementación básica - aquí iría código para registrar eventos
    print('Analytics Event: $name, Params: $parameters');
  }
  
  void logScreen(String screenName) {
    print('Screen View: $screenName');
  }
}