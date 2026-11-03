import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/core/widgets/section_header.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';
import 'package:room_aura/presentation/widgets/room_card.dart';

class StyleDetailScreen extends ConsumerWidget {
  final String styleId;

  const StyleDetailScreen({super.key, required this.styleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(stylesProvider);
    final allProducts = ref.watch(allProductsProvider);
    final inspirations = ref.watch(inspirationRoomsProvider);
    final profile = ref.watch(userProfileProvider);
    final padding = Responsive.screenPadding(context);

    final style = styles.where((s) => s.id == styleId).firstOrNull;
    if (style == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Style not found')),
      );
    }

    final styleProducts = allProducts
        .where(
          (p) => p.styleTags.any(
            (t) => t.toLowerCase() == style.name.toLowerCase(),
          ),
        )
        .toList();

    final styleRooms = inspirations.where((r) => r.styleId == styleId).toList();

    return Scaffold(
      appBar: AppBar(title: Text(style.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final styleImage = ProductImages.forStyle(style.id);
                return Container(
                  width: double.infinity,
                  margin: padding,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: styleImage == null
                        ? Color(style.accentColor).withValues(alpha: 0.12)
                        : null,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    image: styleImage != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(styleImage),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Color(style.accentColor).withValues(alpha: 0.7),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.name,
                        style: AppTypography.displayMedium.copyWith(
                          color: styleImage != null ? Colors.white : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        style.description,
                        style: AppTypography.bodyLarge.copyWith(
                          color: styleImage != null
                              ? Colors.white.withValues(alpha: 0.9)
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        style.moodDescription,
                        style: AppTypography.bodyMedium.copyWith(
                          color: styleImage != null
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: padding,
              child: Text(
                'Characteristics',
                style: AppTypography.headlineMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: padding,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: style.characteristics
                    .map(
                      (c) => Chip(
                        label: Text(c),
                        backgroundColor: AppColors.surfaceVariant,
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: padding,
              child: Text('Color Palette', style: AppTypography.headlineMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: padding,
              child: Row(
                children: style.colorPalette.map((colorVal) {
                  return Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Color(colorVal),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider, width: 1.5),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: padding,
              child: Text('Key Materials', style: AppTypography.headlineMedium),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: padding,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: style.keyMaterials
                    .map(
                      (m) => Chip(
                        label: Text(m),
                        avatar: const Icon(Icons.texture, size: 16),
                        backgroundColor: AppColors.surfaceVariant,
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),
            if (styleProducts.isNotEmpty) ...[
              Padding(
                padding: padding,
                child: SectionHeader(
                  title: '${style.name} Furniture',
                  onSeeAll: () => context.push('/catalog'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: padding,
                  itemCount: styleProducts.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final product = styleProducts[index];
                    return SizedBox(
                      width: 180,
                      child: FurnitureCard(
                        product: product,
                        isFavorite: profile.favoriteProductIds.contains(
                          product.id,
                        ),
                        onTap: () => context.push('/catalog/${product.id}'),
                        onFavoriteToggle: () => ref
                            .read(userProfileProvider.notifier)
                            .toggleFavorite(product.id),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),
            ],
            if (styleRooms.isNotEmpty) ...[
              Padding(
                padding: padding,
                child: SectionHeader(title: '${style.name} Inspiration'),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: padding,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.gridCrossAxisCount(
                      context,
                      mobile: 2,
                      tablet: 3,
                      desktop: 3,
                    ),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: styleRooms.length,
                  itemBuilder: (context, index) {
                    final room = styleRooms[index];
                    return RoomCard(room: room, onTap: () {});
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
