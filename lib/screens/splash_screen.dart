import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _lineWidth;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _titleSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
          ),
        );
    _lineWidth = Tween<double>(begin: 0.0, end: 48.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('trainer_splash_seen', true);
      if (mounted) {
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(AppTheme.deepSlate);

    return Scaffold(
      backgroundColor: palette.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _iconScale,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accent.withValues(alpha: 0.1),
                  border: Border.all(
                    color: palette.accent.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.fitness_center,
                  size: 32,
                  color: palette.accent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleOpacity,
                child: Text(
                  "TRAINER PRO",
                  style: AppleDesignSystem.title1.copyWith(
                    color: palette.accent,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: _lineWidth,
              builder: (context, child) {
                return Container(
                  height: 2,
                  width: _lineWidth.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        palette.accent.withValues(alpha: 0.0),
                        palette.accent,
                        palette.accent.withValues(alpha: 0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            FadeTransition(
              opacity: _taglineOpacity,
              child: Text(
                "TU GYM EN EL BOLSILLO",
                style: AppleDesignSystem.caption3.copyWith(
                  color: palette.textTertiary,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
