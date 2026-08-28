import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _rotate;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _rotate = Tween<double>(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('trainer_splash_seen', true);
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotate.value,
                  child: Transform.scale(
                    scale: _scale.value,
                    child: Opacity(
                      opacity: _opacity.value,
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.12),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.35),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.dumbbell,
                          size: 72,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _opacity,
                child: const Text(
                  "TRAINER PRO",
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _opacity,
              child: const Text(
                "TU GYM EN EL BOLSILLO",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
