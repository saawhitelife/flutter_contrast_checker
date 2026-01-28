import 'package:flutter/material.dart';

@immutable
class ContrastCheckerTheme extends ThemeExtension<ContrastCheckerTheme> {
  const ContrastCheckerTheme({
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.shadow,
    required this.title,
    required this.body,
    required this.muted,
    required this.accent,
    required this.successBg,
    required this.successText,
    required this.errorBg,
    required this.errorText,
    required this.buttonGradientStart,
    required this.buttonGradientEnd,
    required this.lensBackground,
    required this.lensBorder,
    required this.cardGradientStart,
    required this.cardGradientEnd,
  });

  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color shadow;
  final Color title;
  final Color body;
  final Color muted;
  final Color accent;
  final Color successBg;
  final Color successText;
  final Color errorBg;
  final Color errorText;
  final Color buttonGradientStart;
  final Color buttonGradientEnd;
  final Color lensBackground;
  final Color lensBorder;
  final Color cardGradientStart;
  final Color cardGradientEnd;

  static const ContrastCheckerTheme light = ContrastCheckerTheme(
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    shadow: Color(0x260F172A),
    title: Color(0xFF0F172A),
    body: Color(0xFF0F172A),
    muted: Color(0xFF64748B),
    accent: Color(0xFF0EA5E9),
    successBg: Color(0xFFDCFCE7),
    successText: Color(0xFF166534),
    errorBg: Color(0xFFFEE2E2),
    errorText: Color(0xFF991B1B),
    buttonGradientStart: Color(0xFF14B8A6),
    buttonGradientEnd: Color(0xFF0EA5E9),
    lensBackground: Color(0xFFF8FAFC),
    lensBorder: Color(0xFFE2E8F0),
    cardGradientStart: Color(0xFFF8FAFC),
    cardGradientEnd: Color(0xFFE0F2FE),
  );

  static const ContrastCheckerTheme dark = ContrastCheckerTheme(
    surface: Color(0xFF0F172A),
    surfaceAlt: Color(0xFF111827),
    border: Color(0xFF1F2937),
    shadow: Color(0xFF000000),
    title: Color(0xFFF8FAFC),
    body: Color(0xFFE2E8F0),
    muted: Color(0xFF94A3B8),
    accent: Color(0xFF38BDF8),
    successBg: Color(0xFF064E3B),
    successText: Color(0xFF86EFAC),
    errorBg: Color(0xFF7F1D1D),
    errorText: Color(0xFFFCA5A5),
    buttonGradientStart: Color(0xFF22D3EE),
    buttonGradientEnd: Color(0xFF3B82F6),
    lensBackground: Color(0xFF111827),
    lensBorder: Color(0xFF1F2937),
    cardGradientStart: Color(0xFF0B1220),
    cardGradientEnd: Color(0xFF111827),
  );

  @override
  ContrastCheckerTheme copyWith({
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? shadow,
    Color? title,
    Color? body,
    Color? muted,
    Color? accent,
    Color? successBg,
    Color? successText,
    Color? errorBg,
    Color? errorText,
    Color? buttonGradientStart,
    Color? buttonGradientEnd,
    Color? lensBackground,
    Color? lensBorder,
    Color? cardGradientStart,
    Color? cardGradientEnd,
  }) {
    return ContrastCheckerTheme(
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      title: title ?? this.title,
      body: body ?? this.body,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      successBg: successBg ?? this.successBg,
      successText: successText ?? this.successText,
      errorBg: errorBg ?? this.errorBg,
      errorText: errorText ?? this.errorText,
      buttonGradientStart: buttonGradientStart ?? this.buttonGradientStart,
      buttonGradientEnd: buttonGradientEnd ?? this.buttonGradientEnd,
      lensBackground: lensBackground ?? this.lensBackground,
      lensBorder: lensBorder ?? this.lensBorder,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
    );
  }

  @override
  ContrastCheckerTheme lerp(ThemeExtension<ContrastCheckerTheme>? other, double t) {
    if (other is! ContrastCheckerTheme) {
      return this;
    }
    return ContrastCheckerTheme(
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t) ?? surfaceAlt,
      border: Color.lerp(border, other.border, t) ?? border,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      title: Color.lerp(title, other.title, t) ?? title,
      body: Color.lerp(body, other.body, t) ?? body,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      successBg: Color.lerp(successBg, other.successBg, t) ?? successBg,
      successText: Color.lerp(successText, other.successText, t) ?? successText,
      errorBg: Color.lerp(errorBg, other.errorBg, t) ?? errorBg,
      errorText: Color.lerp(errorText, other.errorText, t) ?? errorText,
      buttonGradientStart: Color.lerp(buttonGradientStart, other.buttonGradientStart, t) ?? buttonGradientStart,
      buttonGradientEnd: Color.lerp(buttonGradientEnd, other.buttonGradientEnd, t) ?? buttonGradientEnd,
      lensBackground: Color.lerp(lensBackground, other.lensBackground, t) ?? lensBackground,
      lensBorder: Color.lerp(lensBorder, other.lensBorder, t) ?? lensBorder,
      cardGradientStart: Color.lerp(cardGradientStart, other.cardGradientStart, t) ?? cardGradientStart,
      cardGradientEnd: Color.lerp(cardGradientEnd, other.cardGradientEnd, t) ?? cardGradientEnd,
    );
  }
}

extension ContrastCheckerThemeX on BuildContext {
  ContrastCheckerTheme get contrastCheckerTheme {
    final ContrastCheckerTheme? theme = Theme.of(this).extension<ContrastCheckerTheme>();
    return theme ?? ContrastCheckerTheme.light;
  }
}
