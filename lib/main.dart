import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const FixUApp());
}

class FixUApp extends StatelessWidget {
  const FixUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixU - แอปแจ้งซ่อมในมหาวิทยาลัย ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0066FF),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          primary: const Color(0xFF0066FF),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
