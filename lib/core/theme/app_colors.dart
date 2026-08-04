import 'package:flutter/material.dart';

/// Kinetic Dark color system.
/// Each ramp goes from 900 (darkest) to 50 (lightest), matching
/// the swatches in the design reference.
class AppColors {
  AppColors._();

  // ---- Primary (green) ----
  static const primary = Color(0xFF39FF88);
  static const primaryShades = {
    900: Color(0xFF072D14),
    800: Color(0xFF0E5A28),
    700: Color(0xFF14873C),
    600: Color(0xFF1BB450),
    500: Color(0xFF22E164),
    400: Color(0xFF39FF88), // base
    300: Color(0xFF63FF9F),
    200: Color(0xFF8CFFB7),
    100: Color(0xFFB6FFCF),
    50: Color(0xFFE0FFE7),
  };

  // ---- Secondary (near-black surface) ----
  static const secondary = Color(0xFF1A1A1E);
  static const secondaryShades = {
    900: Color(0xFF000000),
    800: Color(0xFF1A1A1E),
    700: Color(0xFF2E2E33),
    600: Color(0xFF434348),
    500: Color(0xFF58585D),
    400: Color(0xFF6D6D72),
    300: Color(0xFF929296),
    200: Color(0xFFB7B7BA),
    100: Color(0xFFDBDBDC),
    50: Color(0xFFFFFFFF),
  };

  // ---- Tertiary (card/surface gray) ----
  static const tertiary = Color(0xFF242429);
  static const tertiaryShades = {
    900: Color(0xFF000000),
    800: Color(0xFF242429),
    700: Color(0xFF38383D),
    600: Color(0xFF4D4D52),
    500: Color(0xFF616166),
    400: Color(0xFF76767B),
    300: Color(0xFF9B9B9F),
    200: Color(0xFFBFBFC2),
    100: Color(0xFFE2E2E3),
    50: Color(0xFFFFFFFF),
  };

  // ---- Neutral (secondary text / icons) ----
  static const neutral = Color(0xFF9D9D9F);
  static const neutralShades = {
    900: Color(0xFF000000),
    800: Color(0xFF232324),
    700: Color(0xFF464648),
    600: Color(0xFF69696B),
    500: Color(0xFF8B8B8D),
    400: Color(0xFF9D9D9F), // base
    300: Color(0xFFB6B6B8),
    200: Color(0xFFCECED0),
    100: Color(0xFFE7E7E7),
    50: Color(0xFFFFFFFF),
  };

  // ---- Semantic (from the action-chip row: sparkle/shape/tag/delete) ----
  static const info = Color(0xFF39FF88);
  static const danger = Color(0xFFE0554F);

  // ---- Surfaces ----
  static const background = Color(0xFF0D0D0F);
  static const surfaceCard = tertiary; // #242429 card backgrounds
  static const surfaceElevated = Color(0xFF2E2E33);

  // ---- Text ----
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = neutral; // #9D9D9F
  static const textOnPrimary = Color(0xFF0D0D0F); // black text on green btn
}