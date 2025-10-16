// lib/models/task.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart'; 

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String note;

  @HiveField(2)
  final DateTime dueDate;

  @HiveField(3)
  final int colorValue; // El valor entero del color
  
  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  final String reminderInterval;

  @HiveField(6)
  final String repetitionFrequency;

  Task({
    required this.title,
    this.note = '',
    required this.dueDate,
    Color color = Colors.indigo,
    this.isCompleted = false,
    // 🔑 CLAVE: Usamos 'this.' en los parámetros para asignarlos a las variables finales
    this.reminderInterval = 'Ninguno', 
    this.repetitionFrequency = 'Ninguno',
  }) : colorValue = color.value; // ✅ Solución: Volver a usar .value, que Hive entiende.
    
  Color get color => Color(colorValue);
}