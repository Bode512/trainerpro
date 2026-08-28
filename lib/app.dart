import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

class TrainerProApp extends StatefulWidget {
  const TrainerProApp({super.key});

  @override
  State<TrainerProApp> createState() => _TrainerProAppState();
}

class _TrainerProAppState extends State<TrainerProApp> {
  AppTheme _currentTheme = AppTheme.deepSlate;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _checkSplash();
  }

  Future<void> _checkSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('trainer_splash_seen') ?? false;
    if (seen) {
      if (mounted) setState(() => _showSplash = false);
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('app_theme_index');
    if (themeIndex != null) {
      setState(() {
        _currentTheme = AppTheme.values[themeIndex];
      });
    }
  }

  Future<void> _cycleTheme() async {
    final nextTheme =
        AppTheme.values[(_currentTheme.index + 1) % AppTheme.values.length];
    setState(() {
      _currentTheme = nextTheme;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_theme_index', nextTheme.index);
  }

  ThemeData _getThemeData() {
    Color bg;
    Color primary;
    switch (_currentTheme) {
      case AppTheme.cyberNeon:
        bg = const Color(0xFF000000);
        primary = const Color(0xFF00F5FF);
        break;
      case AppTheme.crimsonBlood:
        bg = const Color(0xFF1A0B0B);
        primary = const Color(0xFFFF3131);
        break;
      case AppTheme.toxicGreen:
        bg = const Color(0xFF051105);
        primary = const Color(0xFF22C55E);
        break;
      case AppTheme.solarFlare:
        bg = const Color(0xFF120A00);
        primary = const Color(0xFFF59E0B);
        break;
      default:
        bg = const Color(0xFF020617);
        primary = const Color(0xFF3B82F6);
    }

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      fontFamily: 'Roboto',
      useMaterial3: true,
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border.fromBorderSide(BorderSide(color: Colors.transparent)),
        collapsedShape: Border.fromBorderSide(
          BorderSide(color: Colors.transparent),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: bg,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trainer Pro',
      debugShowCheckedModeBanner: false,
      theme: _getThemeData(),
      home: _showSplash
          ? SplashScreen(onDone: () => setState(() => _showSplash = false))
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Color(0xFF0A0E1A),
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return MainScreen(
                    currentTheme: _currentTheme,
                    onToggleTheme: _cycleTheme,
                  );
                }
                return const AuthScreen();
              },
            ),
    );
  }
}
