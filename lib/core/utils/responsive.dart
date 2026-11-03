import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileBreakpoint) return ScreenSize.mobile;
    if (width < desktopBreakpoint) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getScreenSize(context) == ScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenSize(context) == ScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenSize(context) == ScreenSize.desktop;

  static int gridCrossAxisCount(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    return switch (getScreenSize(context)) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };
  }

  static double contentMaxWidth(BuildContext context) {
    return switch (getScreenSize(context)) {
      ScreenSize.mobile => double.infinity,
      ScreenSize.tablet => 900,
      ScreenSize.desktop => 1200,
    };
  }

  static EdgeInsets screenPadding(BuildContext context) {
    return switch (getScreenSize(context)) {
      ScreenSize.mobile => const EdgeInsets.symmetric(horizontal: 16),
      ScreenSize.tablet => const EdgeInsets.symmetric(horizontal: 24),
      ScreenSize.desktop => const EdgeInsets.symmetric(horizontal: 32),
    };
  }
}
