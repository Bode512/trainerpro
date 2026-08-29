import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<AnimatedNavItem> items;
  final Color accentColor;
  final ValueChanged<int> onTap;
  final ThemePalette palette;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.accentColor,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: AppleDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceBg.withValues(alpha: 0.94),
        border: Border(
          top: BorderSide(
            color: palette.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: AppleDesignSystem.animMedium,
              curve: AppleDesignSystem.curveSmooth,
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 14 : 10,
                vertical: AppleDesignSystem.spacing8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? accentColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppleDesignSystem.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isActive ? 1.15 : 1.0,
                    duration: AppleDesignSystem.animNormal,
                    curve: AppleDesignSystem.curveSpring,
                    child: Icon(
                      items[i].icon,
                      color: isActive ? accentColor : palette.textQuaternary,
                      size: 22,
                    ),
                  ),
                  AnimatedSize(
                    duration: AppleDesignSystem.animMedium,
                    curve: AppleDesignSystem.curveSmooth,
                    child: AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.0,
                      duration: AppleDesignSystem.animFast,
                      child: isActive
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                items[i].label,
                                style: AppleDesignSystem.caption3.copyWith(
                                  color: accentColor,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AnimatedNavItem {
  final IconData icon;
  final String label;

  const AnimatedNavItem({required this.icon, required this.label});
}

class StaggeredListView extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDuration;
  final Duration slideDuration;

  const StaggeredListView({
    super.key,
    required this.children,
    this.staggerDuration = const Duration(milliseconds: 50),
    this.slideDuration = const Duration(milliseconds: 350),
  });

  @override
  State<StaggeredListView> createState() => _StaggeredListViewState();
}

class _StaggeredListViewState extends State<StaggeredListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          widget.staggerDuration * widget.children.length +
          widget.slideDuration,
    );

    _animations = List.generate(widget.children.length, (i) {
      final start =
          (i * widget.staggerDuration.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      final end =
          ((i * widget.staggerDuration.inMilliseconds) +
              widget.slideDuration.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0, 1),
            end.clamp(0, 1),
            curve: AppleDesignSystem.curveSmooth,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[i].value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _animations[i].value)),
                child: child,
              ),
            );
          },
          child: widget.children[i],
        );
      }),
    );
  }
}

class GlowPulse extends StatefulWidget {
  final Widget child;
  final Color color;
  final double intensity;
  final Duration duration;

  const GlowPulse({
    super.key,
    required this.child,
    required this.color,
    this.intensity = 0.6,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<GlowPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppleDesignSystem.radiusL),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: widget.intensity * _animation.value,
                ),
                blurRadius: 20 * _animation.value,
                spreadRadius: 2 * _animation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: widget.child);
        },
        child: widget.child,
      ),
    );
  }
}

class CircularTimer extends StatefulWidget {
  final double progress;
  final int secondsLeft;
  final int totalSeconds;
  final Color accentColor;
  final bool isExpanded;

  const CircularTimer({
    super.key,
    required this.progress,
    required this.secondsLeft,
    required this.totalSeconds,
    required this.accentColor,
    this.isExpanded = false,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final size = widget.isExpanded ? 260.0 : 48.0;
        return AnimatedContainer(
          duration: AppleDesignSystem.animMedium,
          curve: AppleDesignSystem.curveSmooth,
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CircularTimerPainter(
              progress: widget.progress,
              accentColor: widget.accentColor,
              pulseScale: _pulseAnimation.value,
              isExpanded: widget.isExpanded,
            ),
            child: Center(
              child: widget.isExpanded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TIEMPO DE DESCANSO",
                          style: AppleDesignSystem.caption3.copyWith(
                            color: widget.accentColor,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${(widget.secondsLeft ~/ 60)}:${(widget.secondsLeft % 60).toString().padLeft(2, '0')}",
                          style: AppleDesignSystem.largeTitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 52,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final double pulseScale;
  final bool isExpanded;

  _CircularTimerPainter({
    required this.progress,
    required this.accentColor,
    required this.pulseScale,
    required this.isExpanded,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    final bgPaint = Paint()
      ..color = const Color(0xFF2C2C2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isExpanded ? 5 : 2.5;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isExpanded ? 5 : 2.5
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    if (isExpanded) {
      final glowPaint = Paint()
        ..color = accentColor.withValues(alpha: 0.12 * pulseScale)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    if (!isExpanded) {
      final dotPaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, 2.5 * pulseScale, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseScale != pulseScale;
  }
}

class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, anim) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      child: Text('$value', key: ValueKey(value), style: style),
    );
  }
}
