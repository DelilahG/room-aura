import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/core/widgets/empty_state_widget.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? EmptyStateWidget(
              icon: Icons.favorite_border,
              title: 'No favorites yet',
              message: 'Browse the catalog and tap the heart icon to save your favorite pieces.',
              actionLabel: 'Browse Catalog',
              onAction: () => context.push('/catalog'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridCrossAxisCount(context),
                childAspectRatio: 0.65,
                crossAxisSpacing: AppSpacing.itemSpacing,
                mainAxisSpacing: AppSpacing.itemSpacing,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return FurnitureCard(
                  product: product,
                  isFavorite: true,
                  onTap: () => context.push('/catalog/${product.id}'),
                  onFavoriteToggle: () {
                    ref
                        .read(userProfileProvider.notifier)
                        .toggleFavorite(product.id);
                  },
                );
              },
            ),
    );
  }
}
