// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/task.dart';
import 'utils/notification_service.dart'; 
// 🔑 Importamos el SplashScreen para usarlo como pantalla inicial
import 'screens/splash_screen.dart'; 

// 🔑 Declaración Global ÚNICA para el plugin de notificaciones
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  // Asegura que los bindings de Flutter estén listos para llamadas asíncronas.
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es', null);

  // 1. Inicializar Time Zones (¡AQUÍ VA CON AWAIT, Y ES LA ÚNICA LLAMADA!)
  await NotificationService.init(); // <--- 🔑 AWAIT Y POSICIÓN CORRECTA
  
  // 2. --- Inicialización de Notificaciones ---
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  // Solicitar Permisos
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  // --- FIN Inicialización de Notificaciones ---

  // ❌ IMPORTANTE: LA LLAMADA DUPLICADA Y MAL UBICADA HA SIDO ELIMINADA.


  // 3. Inicialización de Hive
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');

  // Abrir la caja de autenticación
  await Hive.openBox<dynamic>('authBox');

  // Ahora sí, ejecutar la aplicación
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // La aplicación ahora inicia en el SplashScreen
      home: SplashScreen(), 
    );
  }
}