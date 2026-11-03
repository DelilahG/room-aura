import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const double pagePadding = 16;
  static const double cardPadding = 16;
  static const double sectionSpacing = 32;
  static const double itemSpacing = 12;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  static const EdgeInsets pageInsets = EdgeInsets.symmetric(
    horizontal: pagePadding,
  );
  static const EdgeInsets cardInsets = EdgeInsets.all(cardPadding);
  static const EdgeInsets screenInsets = EdgeInsets.fromLTRB(16, 16, 16, 0);

  static const double elevationNone = 0;
  static const double elevationSm = 1;
  static const double elevationMd = 3;
  static const double elevationLg = 6;

  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;

  static const double touchTarget = 48;
}
