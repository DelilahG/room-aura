# Room Aura

A portfolio-grade interior design application built with Flutter. Browse furniture, explore design styles, create room layouts with an interactive 2D editor, and manage your design collections.

**All product data, reviews, and user accounts shown are demonstration data for portfolio purposes.**

## Features

- **Discover**: Editorial home page with featured products, style guides, inspiration rooms, collections, and new arrivals
- **Explore**: Browse 12 interior design styles (Scandinavian, Japanese, Industrial, Mid-Century Modern, etc.) and 30 curated inspiration rooms
- **Catalog**: Full product catalog with 120 furniture items across 10 categories, search, filtering by category/style/price, and sorting
- **Room Studio**: Interactive 2D room editor with drag-and-drop furniture placement, rotation, resize, and room templates
- **My Designs**: Manage saved room designs with tabs for all/drafts/completed, plus favorites and recently viewed
- **Profile**: User preferences, favorite style selection, and demo data management
- **AR Screen**: Platform-aware screen that honestly communicates AR requirements (physical Android device needed)

## Tech Stack

- **Framework**: Flutter 3.47+ (Web primary, Android secondary)
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: GoRouter with ShellRoute and bottom navigation
- **Persistence**: SharedPreferences (localStorage on web, SharedPreferences on Android)
- **Typography**: Google Fonts (Playfair Display for display, Inter for body)
- **Architecture**: Clean architecture (presentation / application / domain / data layers)

## Seed Data

| Category          | Count |
|-------------------|-------|
| Furniture Products | 120   |
| Interior Styles   | 12    |
| Inspiration Rooms | 30    |
| Room Templates    | 15    |
| Collections       | 10    |
| Product Reviews   | 80    |
| Categories        | 10    |
| Material Variations | 50  |

All prices are in ETB (Ethiopian Birr). All reviews are prefixed with "Sample review -- demonstration data."

## Getting Started

### Prerequisites

- Flutter SDK 3.47+ installed and on PATH
- Chrome browser (for web development)
- 8 GB RAM minimum

### Setup

```bash
# Clone and enter the project
cd room-aura

# Install dependencies
flutter pub get

# Run on web (Chrome)
flutter run -d chrome

# Or build for production
flutter build web --release
```

The production build output is in `build/web/`. Serve it with any static file server:

```bash
cd build/web
python -m http.server 8080
```

### Running Tests

```bash
flutter test
```

33 tests covering seed data integrity, model serialization, repository queries, and search/filter logic.

### Android Build

```bash
flutter build apk --release
```

Note: AR features require a physical ARCore-compatible Android device and have not been tested without one. The app honestly communicates this on the AR screen.

## Project Structure

```
lib/
  main.dart                          # Entry point
  app.dart                           # MaterialApp.router setup
  core/
    constants/app_constants.dart     # App-wide constants (currency, limits)
    theme/
      app_colors.dart                # Color system (ivory, cream, sage, charcoal)
      app_typography.dart            # Typography scale (Google Fonts)
      app_spacing.dart               # Spacing tokens, radii, elevation
      app_theme.dart                 # Complete ThemeData
    utils/responsive.dart            # Breakpoints and responsive helpers
    widgets/                         # Shared widgets (placeholders, empty states, dialogs)
  data/
    models/                          # Domain models (furniture, room, style, etc.)
    seed/                            # All seed data (120 products, 12 styles, etc.)
    repositories/                    # Data access (furniture, designs, user profile)
  application/
    providers/                       # Riverpod providers (furniture, design, user)
  presentation/
    navigation/app_router.dart       # GoRouter configuration
    screens/                         # All app screens organized by feature
    widgets/                         # Feature-specific widgets (cards, editor canvas)
```

## Design System

- **Primary**: Espresso (#5C4A32)
- **Accent**: Deep Sage (#6B7F62)
- **Background**: Ivory (#F5F0EB)
- **Surface**: White
- **Typography**: Playfair Display (headings) + Inter (body)
- **Corner Radius**: 8/12/16/24px scale
- **Spacing**: 4/8/16/24/32/48/64px scale

## Key Design Decisions

- **CustomPainter for room editor** instead of a 3D engine -- practical for web, lightweight, supports zoom/pan via InteractiveViewer
- **ProductImagePlaceholder** with gradient backgrounds and category icons instead of real product photos
- **SharedPreferences** over Hive for simpler cross-platform persistence without native bindings
- **Google Fonts package** instead of bundled font files to avoid asset management
- **No paid APIs or services** -- everything runs locally with seed data

## License

This project is a portfolio demonstration. All product names, descriptions, and reviews are fictional demonstration data.
