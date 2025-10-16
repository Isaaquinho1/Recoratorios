import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hive/hive.dart'; // Importar Hive para guardar el estado
import 'screens/home_screen.dart';
// ❌ Se eliminó: import 'screens/splash_screen.dart'; (Importación no utilizada)

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Duration get loadingTime => const Duration(milliseconds: 2000);
  
  // Nombre del usuario (DEBES obtenerlo de tu lógica de Auth en un proyecto real)
  final String _loggedInUserName = 'Isaac'; 

  // Función para guardar el estado de sesión
  void _saveSessionAndNavigate(BuildContext context) {
    // Accedemos a la caja de autenticación (abierta como Box<dynamic> en main.dart)
    final authBox = Hive.box<dynamic>('authBox'); // 🔑 CORRECCIÓN: Usar <dynamic>
    
    // 🔑 Guardamos el estado de logueado como 'true'
    authBox.put('isLoggedIn', true);
    // 🔑 Guardamos el nombre del usuario (String), lo cual ahora es posible
    authBox.put('userName', _loggedInUserName);
    
    // Navegamos al Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userName: _loggedInUserName), 
      ),
    );
  }

  // --- Funciones de Autenticación (Retornan null en caso de éxito simulado) ---
  
  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loadingTime).then((value) {
      return null; 
    });
  }

  Future<String?> _recoverPassword(String data) {
    return Future.delayed(loadingTime).then((value) => null);
  }

  Future<String?> _signipUser(SignupData data) {
    return Future.delayed(loadingTime).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
        onSignup: _signipUser,
        
        onSubmitAnimationCompleted: () {
          _saveSessionAndNavigate(context);
        },
      ),
    );
  }
}