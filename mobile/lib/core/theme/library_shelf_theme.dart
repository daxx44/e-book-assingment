import 'package:flutter/material.dart';

/// Dark wooden bookshelf palette matching the premium library mockup.
class LibraryShelfTheme {
  LibraryShelfTheme._();

  static const Color woodDark = Color(0xFF1E1210);
  static const Color woodMid = Color(0xFF2C1814);
  static const Color woodPlank = Color(0xFF3D281F);
  static const Color shelfTop = Color(0xFF9A7B6A);
  static const Color shelfMid = Color(0xFF6D4C41);
  static const Color shelfShadow = Color(0xFF3E2723);
  static const Color shelfGrainLight = Color(0xFFB8956E);
  static const Color shelfGrainDark = Color(0xFF4E342E);
  static const Color shelfFrontFace = Color(0xFF3D2A22);
  static const Color shelfFrontShadow = Color(0xFF261912);
  static const Color shelfBracket = Color(0xFF35241C);
  static const Color shelfBracketEdge = Color(0xFF5C4033);
  static const Color wallRecess = Color(0xFF160D0B);
  static const Color wallRecessEdge = Color(0xFF2A1A15);
  static const Color headerText = Color(0xFFF5F0EB);
  static const Color headerMuted = Color(0xFFB8A99E);
  static const Color navActive = Color(0xFFD4A574);
  static const Color navInactive = Color(0xFF8A7A72);
  static const Color fabBrown = Color(0xFF6D4C41);
  static const Color spotlight = Color(0x44FFCC80);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF352018), woodMid, woodDark],
  );

  static const LinearGradient shelfGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [shelfTop, shelfMid, shelfShadow],
  );

  static const LinearGradient shelfFrontGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [shelfMid, shelfFrontFace, shelfFrontShadow],
  );

  static const LinearGradient alcoveGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF221410), wallRecess, Color(0xFF0F0806)],
  );
}
