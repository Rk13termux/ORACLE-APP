class AuthService {
  // Implementación básica
  bool isAuthenticated = false;
  String? currentUser;
  
  Future<bool> login(String username, String password) async {
    // Simulación de autenticación
    await Future.delayed(const Duration(seconds: 1));
    isAuthenticated = true;
    currentUser = username;
    return true;
  }
  
  Future<void> logout() async {
    isAuthenticated = false;
    currentUser = null;
  }
}