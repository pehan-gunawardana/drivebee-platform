import 'package:flutter/material.dart';

class DriveBeeApp extends StatelessWidget {
  const DriveBeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('🐝 DriveBee'),
        ),
      ),
    );
  }
}