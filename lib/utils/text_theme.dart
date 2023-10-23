import 'package:flutter/material.dart';

abstract class ThemeTextGym {
  static TextStyle textShadowInHomePageCards = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
    shadows: [
      Shadow(
          offset: const Offset(-1, -1),
          color: Colors.black.withOpacity(0.85),
          blurRadius: 3),
      const Shadow(
          offset: Offset(1, 1),
          color: Color.fromARGB(95, 0, 0, 0),
          blurRadius: 3)
    ],
    color: Colors.white,
  );
  static TextStyle textShadowInHomePageHeaders = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    shadows: [
      Shadow(
          offset: const Offset(-1, -1),
          color: Colors.black.withOpacity(0.85),
          blurRadius: 3),
      const Shadow(
          offset: Offset(1, 1),
          color: Color.fromARGB(95, 0, 0, 0),
          blurRadius: 3)
    ],
    color: Colors.white,
  );

  static TextStyle textShadowInHomePageCMS = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
    shadows: [
      const Shadow(
          offset: Offset(-1, -1),
          color: Color.fromARGB(95, 0, 0, 0),
          blurRadius: 3),
      Shadow(
          offset: const Offset(1, 1),
          color: Colors.blue.withOpacity(0.85),
          blurRadius: 3)
    ],
    color: Colors.white,
  );
}
