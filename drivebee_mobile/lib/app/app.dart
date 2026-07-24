import 'package:drivebee_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DriveBeeApp extends StatelessWidget {
  const DriveBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveBee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('🐝 DriveBee'),
        ),
      ),
    );
  }
}