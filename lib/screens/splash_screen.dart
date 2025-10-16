// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../login_page.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Configurar Animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 🔑 Zoom Inverso (Scale): Empieza pequeño (0.8) y termina en 1.0
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 🔑 Fundido (Fade): Empieza casi invisible y termina opaco
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 2. Iniciar la comprobación de sesión y la animación
    _controller.forward().whenComplete(_checkSessionAndNavigate);
  }

  // Función para verificar el estado de la sesión
  void _checkSessionAndNavigate() async {
    // 🔑 CORRECCIÓN: Acceder a la caja como Box<dynamic> para que Hive no lance error
    //             y pueda manejar el String (userName) y el booleano.
    final authBox = Hive.box<dynamic>('authBox'); 
    
    // El método .get() aún requiere especificar el tipo por seguridad,
    // usando la función as<Tipo>() o proporcionando el valor por defecto.
    final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false) as bool;
    final userName = authBox.get('userName', defaultValue: 'Estudiante'); 
    
    // Simular un tiempo mínimo de visualización del splash
    await Future.delayed(const Duration(milliseconds: 500)); 

    Widget destinationScreen;

    if (isLoggedIn) {
      // Nota: Aquí se lanza un error si userName no es String, pero tu lógica Hive ya lo asegura
      destinationScreen = HomeScreen(userName: userName as String); 
    } else {
      destinationScreen = const LoginPage();
    }

    // Navegación final
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => destinationScreen,
          // Transición final suave
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF555FD0); 
    const Color backgroundColor = Color(0xFF2B2C33); 
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        // Aplicar la animación de Fade y Zoom Inverso
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔑 Icono de la Aplicación (Podrías usar un logo aquí)
                Icon(
                  Icons.watch_later_outlined, // Icono de recordatorio
                  size: 100,
                  color: primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  'Task Master',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 100),
                // Animación de carga (como referencia visual)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}