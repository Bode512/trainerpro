import 'package:flutter/material.dart';
import 'dart:ui';

enum AppTheme { deepSlate, cyberNeon, crimsonBlood, toxicGreen, solarFlare }

// ─── APPLE / iOS 26 DESIGN SYSTEM ───────────────────────────────────────────

class AppleDesignSystem {
  AppleDesignSystem._();

  // ─── SPACING (4pt grid) ─────────────────────────────────────────────────
  static const double spacing0 = 0;
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing10 = 10;
  static const double spacing12 = 12;
  static const double spacing14 = 14;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing28 = 28;
  static const double spacing32 = 32;
  static const double spacing36 = 36;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;

  // ─── BORDER RADIUS ──────────────────────────────────────────────────────
  static const double radiusXS = 6;
  static const double radiusS = 10;
  static const double radiusM = 14;
  static const double radiusL = 18;
  static const double radiusXL = 22;
  static const double radiusXXL = 28;
  static const double radiusPill = 100;
  static const double radiusCircle = 999;

  // ─── TYPOGRAPHY ─────────────────────────────────────────────────────────
  static const String fontFamily = '.SF Pro Display';

  static const TextStyle largeTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle title3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.3,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.5,
  );

  static const TextStyle callout = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle subheadline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle footnote = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle caption1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle caption2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle caption3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.3,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.3,
  );

  // ─── BLUR / GLASS ──────────────────────────────────────────────────────
  static double get glassBlur => 25.0;
  static double get glassOpacity => 0.72;
  static double get overlayBlur => 40.0;
  static double get overlayOpacity => 0.85;

  // ─── SHADOWS ────────────────────────────────────────────────────────────
  static List<BoxShadow> shadowS(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowM(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowL(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowGlow(Color color, {double intensity = 0.3}) => [
    BoxShadow(
      color: color.withValues(alpha: intensity),
      blurRadius: 20,
      spreadRadius: -2,
    ),
  ];

  // ─── ANIMATION DURATIONS ────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  static const Curve curveSpring = Curves.easeOutBack;
  static const Curve curveSmooth = Curves.easeOutCubic;
  static const Curve curveSnappy = Curves.easeOutQuart;
  static const Curve curveBounce = Curves.elasticOut;
}

// ─── THEME PALETTE ──────────────────────────────────────────────────────────

class ThemePalette {
  final Color scaffoldBg;
  final Color surfaceBg;
  final Color cardBg;
  final Color cardBgElevated;
  final Color accent;
  final Color accentLight;
  final Color accentDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textQuaternary;
  final Color separator;
  final Color fill;
  final Color fillSecondary;
  final Color overlay;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  const ThemePalette({
    required this.scaffoldBg,
    required this.surfaceBg,
    required this.cardBg,
    required this.cardBgElevated,
    required this.accent,
    required this.accentLight,
    required this.accentDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textQuaternary,
    required this.separator,
    required this.fill,
    required this.fillSecondary,
    required this.overlay,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });
}

ThemePalette getPalette(AppTheme theme) {
  switch (theme) {
    case AppTheme.deepSlate:
      return const ThemePalette(
        scaffoldBg: Color(0xFF000000),
        surfaceBg: Color(0xFF0C0C0E),
        cardBg: Color(0xFF1C1C1E),
        cardBgElevated: Color(0xFF2C2C2E),
        accent: Color(0xFF0A84FF),
        accentLight: Color(0xFF409CFF),
        accentDark: Color(0xFF0060CC),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFEBEBF5),
        textTertiary: Color(0xFFEBEBF599),
        textQuaternary: Color(0xFFEBEBF54D),
        separator: Color(0xFF38383A),
        fill: Color(0xFF78788033),
        fillSecondary: Color(0xFF78788029),
        overlay: Color(0xFF00000099),
        error: Color(0xFFFF453A),
        success: Color(0xFF30D158),
        warning: Color(0xFFFFD60A),
        info: Color(0xFF64D2FF),
      );
    case AppTheme.cyberNeon:
      return const ThemePalette(
        scaffoldBg: Color(0xFF000000),
        surfaceBg: Color(0xFF0A0A0C),
        cardBg: Color(0xFF1A1A2E),
        cardBgElevated: Color(0xFF252540),
        accent: Color(0xFF00E5FF),
        accentLight: Color(0xFF40ECFF),
        accentDark: Color(0xFF00B2CC),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFE0F7FA),
        textTertiary: Color(0xFFE0F7FA99),
        textQuaternary: Color(0xFFE0F7FA4D),
        separator: Color(0xFF2A2A4A),
        fill: Color(0xFF78788033),
        fillSecondary: Color(0xFF78788029),
        overlay: Color(0xFF00000099),
        error: Color(0xFFFF453A),
        success: Color(0xFF00E676),
        warning: Color(0xFFFFD60A),
        info: Color(0xFF00E5FF),
      );
    case AppTheme.crimsonBlood:
      return const ThemePalette(
        scaffoldBg: Color(0xFF000000),
        surfaceBg: Color(0xFF0C0505),
        cardBg: Color(0xFF1E1010),
        cardBgElevated: Color(0xFF2E1818),
        accent: Color(0xFFFF4530),
        accentLight: Color(0xFFFF6B5A),
        accentDark: Color(0xFFCC2A18),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFFFEBE9),
        textTertiary: Color(0xFFFFEBE999),
        textQuaternary: Color(0xFFFFEBE94D),
        separator: Color(0xFF3A1E1E),
        fill: Color(0xFFFF453020),
        fillSecondary: Color(0xFFFF453015),
        overlay: Color(0xFF00000099),
        error: Color(0xFFFF453A),
        success: Color(0xFF30D158),
        warning: Color(0xFFFFD60A),
        info: Color(0xFFFF6B5A),
      );
    case AppTheme.toxicGreen:
      return const ThemePalette(
        scaffoldBg: Color(0xFF000000),
        surfaceBg: Color(0xFF040A04),
        cardBg: Color(0xFF0E1E0E),
        cardBgElevated: Color(0xFF162E16),
        accent: Color(0xFF30D158),
        accentLight: Color(0xFF5EE07E),
        accentDark: Color(0xFF1FAA40),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFE8F5E9),
        textTertiary: Color(0xFFE8F5E999),
        textQuaternary: Color(0xFFE8F5E94D),
        separator: Color(0xFF1E3A1E),
        fill: Color(0xFF30D15820),
        fillSecondary: Color(0xFF30D15815),
        overlay: Color(0xFF00000099),
        error: Color(0xFFFF453A),
        success: Color(0xFF30D158),
        warning: Color(0xFFFFD60A),
        info: Color(0xFF64D2FF),
      );
    case AppTheme.solarFlare:
      return const ThemePalette(
        scaffoldBg: Color(0xFF000000),
        surfaceBg: Color(0xFF0A0700),
        cardBg: Color(0xFF1E1500),
        cardBgElevated: Color(0xFF2E2000),
        accent: Color(0xFFFFD60A),
        accentLight: Color(0xFFFFE14D),
        accentDark: Color(0xFFCCAB00),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFFFF8E1),
        textTertiary: Color(0xFFFFF8E199),
        textQuaternary: Color(0xFFFFF8E14D),
        separator: Color(0xFF3A3000),
        fill: Color(0xFFFFD60A20),
        fillSecondary: Color(0xFFFFD60A15),
        overlay: Color(0xFF00000099),
        error: Color(0xFFFF453A),
        success: Color(0xFF30D158),
        warning: Color(0xFFFFD60A),
        info: Color(0xFF64D2FF),
      );
  }
}

// ─── COMPONENT STYLES ───────────────────────────────────────────────────────

class AppleComponents {
  AppleComponents._();

  // ─── GLASS CONTAINER ───────────────────────────────────────────────────
  static BoxDecoration glassContainer({
    required Color accentColor,
    double opacity = 0.08,
    double borderOpacity = 0.12,
    double radius = AppleDesignSystem.radiusL,
  }) {
    return BoxDecoration(
      color: accentColor.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: accentColor.withValues(alpha: borderOpacity),
        width: 0.5,
      ),
    );
  }

  // ─── CARD ───────────────────────────────────────────────────────────────
  static BoxDecoration card({
    required ThemePalette palette,
    double radius = AppleDesignSystem.radiusL,
    bool elevated = false,
  }) {
    final bgColor = elevated ? palette.cardBgElevated : palette.cardBg;
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: palette.separator.withValues(alpha: 0.5),
        width: 0.5,
      ),
    );
  }

  // ─── ELEVATED CARD ──────────────────────────────────────────────────────
  static BoxDecoration elevatedCard({
    required ThemePalette palette,
    double radius = AppleDesignSystem.radiusXL,
  }) {
    return BoxDecoration(
      color: palette.cardBgElevated,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ─── INPUT FIELD ────────────────────────────────────────────────────────
  static InputDecoration inputDecoration({
    required ThemePalette palette,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppleDesignSystem.caption1.copyWith(
        color: palette.textQuaternary,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: palette.fill,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
        borderSide: BorderSide(
          color: palette.error.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
        borderSide: BorderSide(
          color: palette.error,
          width: 1.5,
        ),
      ),
    );
  }

  // ─── PRIMARY BUTTON ─────────────────────────────────────────────────────
  static BoxDecoration primaryButton({
    required ThemePalette palette,
    double radius = AppleDesignSystem.radiusM,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [palette.accent, palette.accent.withValues(alpha: 0.85)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: palette.accent.withValues(alpha: 0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ─── SECONDARY BUTTON ───────────────────────────────────────────────────
  static BoxDecoration secondaryButton({
    required ThemePalette palette,
    double radius = AppleDesignSystem.radiusM,
  }) {
    return BoxDecoration(
      color: palette.fill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: palette.separator.withValues(alpha: 0.5),
        width: 0.5,
      ),
    );
  }

  // ─── PILL BADGE ─────────────────────────────────────────────────────────
  static BoxDecoration pillBadge({
    required Color color,
    double radius = AppleDesignSystem.radiusPill,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // ─── SEPARATOR ──────────────────────────────────────────────────────────
  static Widget separator({required ThemePalette palette}) {
    return Container(
      height: 0.5,
      color: palette.separator.withValues(alpha: 0.5),
    );
  }

  // ─── SECTION HEADER ─────────────────────────────────────────────────────
  static Widget sectionHeader(String title, ThemePalette palette) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppleDesignSystem.spacing4,
        bottom: AppleDesignSystem.spacing8,
      ),
      child: Text(
        title,
        style: AppleDesignSystem.caption3.copyWith(
          color: palette.textTertiary,
        ),
      ),
    );
  }
}
