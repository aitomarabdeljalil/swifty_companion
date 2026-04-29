import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightCard = Color(0xFFEAEFF5);
  static const Color darkBackground = Color(0xFF121417);
  static const Color darkCard = Color(0xFF1C2126);
  static const Color successLight = Color(0xFF1B8A3C);
  static const Color failureLight = Color(0xFFC0392B);
  static const Color successDark = Color(0xFF43C26B);
  static const Color failureDark = Color(0xFFFF6B6B);
  static const Color coalitionFallback = Color(0xFF1B4965);

  static Color background(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : lightBackground;
  }

  static Color card(Brightness brightness) {
    return brightness == Brightness.dark ? darkCard : lightCard;
  }

  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? Colors.white70 : Colors.black87;
  }

  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? Colors.white54 : Colors.black54;
  }

  static Color shadow(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withOpacity(0.25)
        : Colors.black.withOpacity(0.08);
  }

  static Color overlay(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withOpacity(0.6)
        : Colors.black.withOpacity(0.5);
  }

  static Color textOnImage(Brightness brightness) {
    return Colors.white;
  }

  static Color iconOnImage(Brightness brightness) {
    return Colors.white70;
  }

  static Color success(Brightness brightness) {
    return brightness == Brightness.dark ? successDark : successLight;
  }

  static Color failure(Brightness brightness) {
    return brightness == Brightness.dark ? failureDark : failureLight;
  }
}
