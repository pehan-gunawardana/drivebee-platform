import 'package:drivebee_mobile/core/router/app_router.dart';
import 'package:drivebee_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DriveBeeApp extends StatelessWidget {
  const DriveBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DriveBee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}