import 'package:flutter/material.dart';

@immutable
class ShortcutTokens extends ThemeExtension<ShortcutTokens> {
  const ShortcutTokens({
    required this.accent,
    required this.bodyText,
    required this.border,
    required this.surface,
    required this.canvas,
    required this.disabledSurface,
    required this.spaceSmall,
    required this.spaceMedium,
    required this.spaceLarge,
    required this.cornerRadius,
  });

  static const reference = ShortcutTokens(
    accent: Color(0xFFD92F55),
    bodyText: Color(0xFF4A5565),
    border: Color(0xFFF3F4F6),
    surface: Color(0xFFFFFFFF),
    canvas: Color(0xFFF8F9FB),
    disabledSurface: Color(0xFFE5E7EB),
    spaceSmall: 8,
    spaceMedium: 12,
    spaceLarge: 24,
    cornerRadius: 12,
  );

  static const cardShadows = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x19000000),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
  ];

  final Color accent;
  final Color bodyText;
  final Color border;
  final Color surface;
  final Color canvas;
  final Color disabledSurface;
  final double spaceSmall;
  final double spaceMedium;
  final double spaceLarge;
  final double cornerRadius;

  static ShortcutTokens of(BuildContext context) {
    return Theme.of(context).extension<ShortcutTokens>() ?? reference;
  }

  @override
  ShortcutTokens copyWith({
    Color? accent,
    Color? bodyText,
    Color? border,
    Color? surface,
    Color? canvas,
    Color? disabledSurface,
    double? spaceSmall,
    double? spaceMedium,
    double? spaceLarge,
    double? cornerRadius,
  }) {
    return ShortcutTokens(
      accent: accent ?? this.accent,
      bodyText: bodyText ?? this.bodyText,
      border: border ?? this.border,
      surface: surface ?? this.surface,
      canvas: canvas ?? this.canvas,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      spaceSmall: spaceSmall ?? this.spaceSmall,
      spaceMedium: spaceMedium ?? this.spaceMedium,
      spaceLarge: spaceLarge ?? this.spaceLarge,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }

  @override
  ShortcutTokens lerp(ThemeExtension<ShortcutTokens>? other, double t) {
    if (other is! ShortcutTokens) return this;
    return ShortcutTokens(
      accent: Color.lerp(accent, other.accent, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      border: Color.lerp(border, other.border, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t)!,
      spaceSmall: spaceSmall + (other.spaceSmall - spaceSmall) * t,
      spaceMedium: spaceMedium + (other.spaceMedium - spaceMedium) * t,
      spaceLarge: spaceLarge + (other.spaceLarge - spaceLarge) * t,
      cornerRadius: cornerRadius + (other.cornerRadius - cornerRadius) * t,
    );
  }
}
