import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveBee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const LoginScreen(),
    );
  }
}