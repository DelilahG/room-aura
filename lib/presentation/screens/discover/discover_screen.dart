import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/core/widgets/section_header.dart';
import 'package:room_aura/core/widgets/search_bar_widget.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';
import 'package:room_aura/presentation/widgets/style_card.dart';
import 'package:room_aura/presentation/widgets/room_card.dart';
import 'package:room_aura/presentation/widgets/collection_card.dart';
import 'package:room_aura/presentation/widgets/template_card.dart';
import 'package:room_aura/core/widgets/cart_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredProductsProvider);
    final styles = ref.watch(stylesProvider);
    final inspirations = ref.watch(inspirationRoomsProvider);
    final collections = ref.watch(collectionsProvider);
    final newArrivals = ref.watch(newProductsProvider);
    final templates = ref.watch(templatesProvider);
    final recentlyViewed = ref.watch(recentlyViewedProductsProvider);
    final profile = ref.watch(userProfileProvider);
    final padding = Responsive.screenPadding(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: padding.copyWith(top: AppSpacing.sm),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [CartIconButton()],
                ),
              ),
              _HeroSection(padding: padding),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: padding,
                child: GestureDetector(
                  onTap: () => context.push('/search'),
                  child: const AbsorbPointer(
                    child: SearchBarWidget(
                      hintText: 'Search furniture, styles, rooms...',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),
              if (featured.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'Featured Furniture',
                    onSeeAll: () => context.push('/catalog'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: featured.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = featured[index];
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
              if (styles.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'Interior Styles',
                    onSeeAll: () => context.push('/explore'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: styles.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final style = styles[index];
                      return SizedBox(
                        width: 150,
                        child: StyleCard(
                          style: style,
                          onTap: () =>
                              context.push('/explore/style/${style.id}'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),
              ],
              if (inspirations.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'Get Inspired',
                    onSeeAll: () => context.push('/explore'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: padding,
                  child: _InspirationGrid(rooms: inspirations.take(6).toList()),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),
              ],
              if (collections.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'Curated Collections',
                    onSeeAll: () => context.push('/explore'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: collections.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return SizedBox(
                        width: 220,
                        child: CollectionCard(
                          collection: collection,
                          onTap: () => context.push('/explore'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),
              ],
              if (newArrivals.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'New Arrivals',
                    onSeeAll: () => context.push('/catalog'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: newArrivals.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = newArrivals[index];
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
              if (templates.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: SectionHeader(
                    title: 'Room Templates',
                    onSeeAll: () => context.push('/room-studio'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: templates.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return SizedBox(
                        width: 200,
                        child: TemplateCard(
                          template: template,
                          onTap: () => context.push('/room-studio'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionSpacing),
              ],
              if (recentlyViewed.isNotEmpty) ...[
                Padding(
                  padding: padding,
                  child: const SectionHeader(title: 'Recently Viewed'),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: padding,
                    itemCount: recentlyViewed.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = recentlyViewed[index];
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
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final EdgeInsets padding;

  const _HeroSection({required this.padding});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Container(
      width: double.infinity,
      margin: padding,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.xxxl : AppSpacing.xl,
        vertical: isDesktop ? AppSpacing.xxxl : AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(ProductImages.heroBanner),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xCC3D2E1A), BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.appName,
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.sand,
              letterSpacing: 2,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Imagine it.\nPlace it.\nMake it yours.',
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.cream,
              fontSize: isDesktop ? 44 : 32,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Discover furniture, design rooms, and bring your\ninterior vision to life.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.sand.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => context.push('/room-studio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cream,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Start Designing'),
          ),
        ],
      ),
    );
  }
}

class _InspirationGrid extends StatelessWidget {
  final List rooms;

  const _InspirationGrid({required this.rooms});

  @override
  Widget build(BuildContext context) {
    final crossCount = Responsive.gridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 3,
    );
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.2,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCard(room: room, onTap: () => context.push('/explore'));
      },
    );
  }
}
