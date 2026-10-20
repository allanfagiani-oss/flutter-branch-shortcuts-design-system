import 'package:flutter/material.dart';

import 'shortcut_tokens.dart';

abstract final class DesignSystemTheme {
  static ThemeData light() {
    const tokens = ShortcutTokens.reference;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: tokens.accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: tokens.accent,
      onPrimary: Colors.white,
      surface: tokens.surface,
      onSurface: tokens.bodyText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.canvas,
      extensions: const [tokens],
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: tokens.disabledSurface,
          disabledForegroundColor: tokens.bodyText,
          minimumSize: const Size(48, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 12,
            height: 1.67,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: tokens.accent, width: 2);
            }
            return BorderSide.none;
          }),
        ),
      ),
    );
  }
}
