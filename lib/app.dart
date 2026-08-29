import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      if (mounted) {
        setState(() => _showSplash = false);
      }
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
    final palette = getPalette(_currentTheme);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.scaffoldBg,
      primaryColor: palette.accent,
      fontFamily: '.SF Pro Display',
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: palette.accent,
        secondary: palette.accentLight,
        surface: palette.surfaceBg,
        error: palette.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: palette.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppleDesignSystem.headline.copyWith(
          color: palette.textPrimary,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: palette.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusL),
          side: BorderSide(
            color: palette.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusXL),
        ),
        titleTextStyle: AppleDesignSystem.headline.copyWith(
          color: palette.textPrimary,
        ),
        contentTextStyle: AppleDesignSystem.subheadline.copyWith(
          color: palette.textSecondary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.cardBg,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppleDesignSystem.radiusXL),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.cardBgElevated,
        contentTextStyle: AppleDesignSystem.subheadline.copyWith(
          color: palette.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent;
          }
          return palette.textQuaternary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent.withValues(alpha: 0.3);
          }
          return palette.fill;
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppleDesignSystem.spacing16,
        ),
        titleTextStyle: AppleDesignSystem.subheadline.copyWith(
          color: palette.textPrimary,
        ),
        subtitleTextStyle: AppleDesignSystem.caption1.copyWith(
          color: palette.textTertiary,
        ),
        iconColor: palette.textSecondary,
      ),
      dividerTheme: DividerThemeData(
        color: palette.separator.withValues(alpha: 0.5),
        thickness: 0.5,
        space: 0,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: palette.accent,
        collapsedIconColor: palette.textTertiary,
        textColor: palette.textPrimary,
        collapsedTextColor: palette.textPrimary,
        shape: const Border.fromBorderSide(BorderSide(color: Colors.transparent)),
        collapsedShape: const Border.fromBorderSide(
          BorderSide(color: Colors.transparent),
        ),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppleDesignSystem.spacing16,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: palette.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          side: BorderSide(
            color: palette.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          textStyle: AppleDesignSystem.subheadline.copyWith(
            color: palette.accent,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppleDesignSystem.spacing24,
            vertical: AppleDesignSystem.spacing14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          ),
          textStyle: AppleDesignSystem.subheadline.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppleDesignSystem.spacing24,
            vertical: AppleDesignSystem.spacing14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          ),
          side: BorderSide(
            color: palette.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
          textStyle: AppleDesignSystem.subheadline.copyWith(
            color: palette.textPrimary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.fill,
        hintStyle: AppleDesignSystem.caption1.copyWith(
          color: palette.textQuaternary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppleDesignSystem.spacing16,
          vertical: AppleDesignSystem.spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          borderSide: BorderSide(
            color: palette.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
          borderSide: BorderSide(
            color: palette.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(_currentTheme);

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
                  return Scaffold(
                    backgroundColor: palette.scaffoldBg,
                    body: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: palette.accent,
                        ),
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
