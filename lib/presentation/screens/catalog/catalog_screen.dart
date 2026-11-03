import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';
import 'package:room_aura/presentation/widgets/category_chip.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final styles = ref.watch(stylesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedStyle = ref.watch(selectedStyleProvider);
    final sortBy = ref.watch(sortByProvider);
    final profile = ref.watch(userProfileProvider);
    final padding = Responsive.screenPadding(context);
    final crossCount = Responsive.gridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          if (Responsive.isMobile(context))
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () =>
                  _showFilterSheet(context, ref, categories, styles),
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: padding.copyWith(
                top: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              itemCount: categories.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryChip(
                    name: 'All',
                    isSelected: selectedCategory == null,
                    onTap: () =>
                        ref.read(selectedCategoryProvider.notifier).state =
                            null,
                  );
                }
                final cat = categories[index - 1];
                return CategoryChip(
                  name: cat.name,
                  isSelected: selectedCategory == cat.id,
                  onTap: () =>
                      ref.read(selectedCategoryProvider.notifier).state =
                          cat.id,
                );
              },
            ),
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: padding,
              child: Row(
                children: [
                  _StyleDropdown(
                    styles: styles,
                    selectedStyle: selectedStyle,
                    onChanged: (val) =>
                        ref.read(selectedStyleProvider.notifier).state = val,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _SortDropdown(
                    sortBy: sortBy,
                    onChanged: (val) =>
                        ref.read(sortByProvider.notifier).state = val ?? 'name',
                  ),
                  const Spacer(),
                  Text(
                    '${filteredProducts.length} products',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          if (Responsive.isMobile(context))
            Padding(
              padding: padding.copyWith(top: 0, bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredProducts.length} products',
                    style: AppTypography.bodySmall,
                  ),
                  _SortDropdown(
                    sortBy: sortBy,
                    onChanged: (val) =>
                        ref.read(sortByProvider.notifier).state = val ?? 'name',
                  ),
                ],
              ),
            ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 56,
                          color: AppColors.silver,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No products match your filters',
                          style: AppTypography.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () {
                            ref.read(selectedCategoryProvider.notifier).state =
                                null;
                            ref.read(selectedStyleProvider.notifier).state =
                                null;
                            ref.read(minPriceProvider.notifier).state = null;
                            ref.read(maxPriceProvider.notifier).state = null;
                          },
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: padding.copyWith(
                      top: AppSpacing.sm,
                      bottom: AppSpacing.xxl,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return FurnitureCard(
                        product: product,
                        isFavorite: profile.favoriteProductIds.contains(
                          product.id,
                        ),
                        onTap: () => context.push('/catalog/${product.id}'),
                        onFavoriteToggle: () => ref
                            .read(userProfileProvider.notifier)
                            .toggleFavorite(product.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    List categories,
    List styles,
  ) {
    final selectedStyle = ref.read(selectedStyleProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Filters', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.lg),
              Text('Style', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ChoiceChip(
                    label: const Text('All Styles'),
                    selected: selectedStyle == null,
                    onSelected: (_) {
                      ref.read(selectedStyleProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                  ),
                  ...styles.map(
                    (s) => ChoiceChip(
                      label: Text(s.name),
                      selected: selectedStyle == s.id,
                      onSelected: (_) {
                        ref.read(selectedStyleProvider.notifier).state = s.id;
                        Navigator.pop(context);
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selectedStyle == s.id
                            ? AppColors.textOnDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            null;
                        ref.read(selectedStyleProvider.notifier).state = null;
                        ref.read(minPriceProvider.notifier).state = null;
                        ref.read(maxPriceProvider.notifier).state = null;
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleDropdown extends StatelessWidget {
  final List styles;
  final String? selectedStyle;
  final ValueChanged<String?> onChanged;

  const _StyleDropdown({
    required this.styles,
    required this.selectedStyle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedStyle,
          hint: const Text('All Styles'),
          isDense: true,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('All Styles'),
            ),
            ...styles.map(
              (s) =>
                  DropdownMenuItem<String?>(value: s.id, child: Text(s.name)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String?> onChanged;

  const _SortDropdown({required this.sortBy, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: sortBy,
          isDense: true,
          items: const [
            DropdownMenuItem(value: 'name', child: Text('Name')),
            DropdownMenuItem(
              value: 'price_asc',
              child: Text('Price: Low to High'),
            ),
            DropdownMenuItem(
              value: 'price_desc',
              child: Text('Price: High to Low'),
            ),
            DropdownMenuItem(value: 'rating', child: Text('Rating')),
            DropdownMenuItem(value: 'newest', child: Text('Newest')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
