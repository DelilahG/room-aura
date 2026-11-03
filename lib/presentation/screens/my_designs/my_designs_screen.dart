import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/widgets/section_header.dart';
import 'package:room_aura/core/widgets/empty_state_widget.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/application/providers/design_providers.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/presentation/widgets/design_card.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';

class MyDesignsScreen extends ConsumerWidget {
  const MyDesignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designs = ref.watch(allDesignsProvider);
    final favoriteProducts = ref.watch(favoriteProductsProvider);
    final recentProducts = ref.watch(recentlyViewedProductsProvider);

    final drafts = designs.where((d) => d.isDraft).toList();
    final completed = designs.where((d) => !d.isDraft).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Designs', style: AppTypography.headlineLarge),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Drafts'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDesignsTab(
              context,
              ref,
              designs,
              'No designs yet',
              'Create your first room design to see it here.',
              favoriteProducts,
              recentProducts,
            ),
            _buildDesignsTab(
              context,
              ref,
              drafts,
              'No drafts',
              'Designs you\'re working on will appear here.',
              null,
              null,
            ),
            _buildDesignsTab(
              context,
              ref,
              completed,
              'No completed designs',
              'Mark designs as complete when you\'re happy with them.',
              null,
              null,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/room-studio/new'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          icon: const Icon(Icons.add_rounded),
          label: const Text('New Design'),
        ),
      ),
    );
  }

  Widget _buildDesignsTab(
    BuildContext context,
    WidgetRef ref,
    List designs,
    String emptyTitle,
    String emptySubtitle,
    List? favorites,
    List? recent,
  ) {
    final isMobile = Responsive.isMobile(context);

    return ListView(
      padding: Responsive.screenPadding(context)
          .copyWith(top: AppSpacing.md, bottom: 100),
      children: [
        if (designs.isEmpty)
          EmptyStateWidget(
            icon: Icons.dashboard_outlined,
            title: emptyTitle,
            message: emptySubtitle,
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.gridCrossAxisCount(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 3,
              ),
              childAspectRatio: isMobile ? 1.6 : 1.4,
              crossAxisSpacing: AppSpacing.itemSpacing,
              mainAxisSpacing: AppSpacing.itemSpacing,
            ),
            itemCount: designs.length,
            itemBuilder: (context, index) {
              final d = designs[index];
              return DesignCard(
                design: d,
                onTap: () => context.go('/room-studio/edit/${d.id}'),
                onDelete: () => _confirmDelete(context, ref, d.id),
                onDuplicate: () =>
                    ref.read(allDesignsProvider.notifier).duplicate(d.id),
              );
            },
          ),
        if (favorites != null && favorites.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sectionSpacing),
          SectionHeader(title: 'Favorites (${favorites.length})'),
          const SizedBox(height: AppSpacing.itemSpacing),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.itemSpacing),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 170,
                  child: FurnitureCard(
                    product: favorites[index],
                    onTap: () =>
                        context.push('/catalog/${favorites[index].id}'),
                    onFavoriteToggle: () => ref
                        .read(userProfileProvider.notifier)
                        .toggleFavorite(favorites[index].id),
                    isFavorite: true,
                  ),
                );
              },
            ),
          ),
        ],
        if (recent != null && recent.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sectionSpacing),
          SectionHeader(title: 'Recently Viewed (${recent.length})'),
          const SizedBox(height: AppSpacing.itemSpacing),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recent.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.itemSpacing),
              itemBuilder: (context, index) {
                final p = recent[index];
                final favIds = ref
                    .watch(userProfileProvider)
                    .favoriteProductIds;
                return SizedBox(
                  width: 170,
                  child: FurnitureCard(
                    product: p,
                    onTap: () => context.push('/catalog/${p.id}'),
                    onFavoriteToggle: () => ref
                        .read(userProfileProvider.notifier)
                        .toggleFavorite(p.id),
                    isFavorite: favIds.contains(p.id),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Design'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(allDesignsProvider.notifier).delete(id);
    }
  }
}
