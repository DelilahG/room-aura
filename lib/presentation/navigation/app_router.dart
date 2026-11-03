import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/discover/discover_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/explore/style_detail_screen.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/catalog/product_detail_screen.dart';
import '../screens/room_studio/room_studio_screen.dart';
import '../screens/room_studio/room_create_screen.dart';
import '../screens/room_studio/room_editor_screen.dart';
import '../screens/ar/ar_screen.dart';
import '../screens/my_designs/my_designs_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/favorites_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../../core/theme/app_colors.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter({bool showOnboarding = false}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: showOnboarding ? '/onboarding' : '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DiscoverScreen()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ExploreScreen()),
        ),
        GoRoute(
          path: '/room-studio',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RoomStudioScreen()),
        ),
        GoRoute(
          path: '/my-designs',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MyDesignsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/explore/style/:styleId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          StyleDetailScreen(styleId: state.pathParameters['styleId']!),
    ),
    GoRoute(
      path: '/catalog',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CatalogScreen(),
    ),
    GoRoute(
      path: '/catalog/:productId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          ProductDetailScreen(productId: state.pathParameters['productId']!),
    ),
    GoRoute(
      path: '/room-studio/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RoomCreateScreen(),
    ),
    GoRoute(
      path: '/room-studio/edit/:designId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          RoomEditorScreen(designId: state.pathParameters['designId']!),
    ),
    GoRoute(
      path: '/room-studio/ar/:productId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          ArScreen(productId: state.pathParameters['productId']),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/cart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/favorites',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location == '/explore') return 1;
    if (location == '/room-studio') return 2;
    if (location == '/my-designs') return 3;
    if (location == '/profile') return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _calculateIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
            case 1:
              context.go('/explore');
            case 2:
              context.go('/room-studio');
            case 3:
              context.go('/my-designs');
            case 4:
              context.go('/profile');
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.sand.withValues(alpha: 0.5),
        surfaceTintColor: Colors.transparent,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(Icons.dashboard_customize),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'My Designs',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
