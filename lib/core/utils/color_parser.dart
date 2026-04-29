import 'package:flutter/material.dart';

class ColorParser {
  static Color parseHex(String? hex, {Color fallback = Colors.blue}) {
    if (hex == null || hex.isEmpty) {
      return fallback;
    }

    final cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length != 6 && cleaned.length != 8) {
      return fallback;
    }

    final buffer = StringBuffer();
    if (cleaned.length == 6) {
      buffer.write('FF');
    }
    buffer.write(cleaned);

    final value = int.tryParse(buffer.toString(), radix: 16);
    if (value == null) {
      return fallback;
    }

    return Color(value);
  }
}
