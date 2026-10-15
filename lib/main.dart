// ============================================================
// NOUR'S RIDE: EL-BITASH
// A game by Nour Eldin
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // شاشة عرضية إجبارية
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // شاشة كاملة
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const BitashApp());
}

class BitashApp extends StatelessWidget {
  const BitashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nour's Ride: El-Bitash",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1410),
        fontFamily: 'monospace',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFCC00),
          secondary: Color(0xFF4A90C2),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MenuScreen(),
      },
    );
  }
}