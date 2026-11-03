import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:room_aura/core/widgets/section_header.dart';
import 'package:room_aura/core/widgets/rating_stars.dart';
import 'package:room_aura/core/widgets/price_tag.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/widgets/product_image_placeholder.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/application/providers/cart_providers.dart';
import 'package:room_aura/data/models/cart.dart';
import 'package:room_aura/presentation/widgets/furniture_card.dart';
import 'package:room_aura/core/widgets/cart_icon_button.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProfileProvider.notifier)
          .addRecentlyViewed(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productDetailProvider(widget.productId));
    final reviews = ref.watch(productReviewsProvider(widget.productId));
    final related = ref.watch(relatedProductsProvider(widget.productId));
    final profile = ref.watch(userProfileProvider);
    final padding = Responsive.screenPadding(context);
    final isFavorite = profile.favoriteProductIds.contains(widget.productId);
    final isDesktop = Responsive.isDesktop(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    final selectedColor = product.availableColors.isNotEmpty
        ? product.availableColors[_selectedColorIndex.clamp(
            0,
            product.availableColors.length - 1,
          )]
        : null;

    Widget body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: isDesktop ? 2.2 : 1.1,
            child: ProductImagePlaceholder(
              category: product.category,
              colorValue: selectedColor?.colorValue ?? 0xFF8B7355,
              imageUrl: ProductImages.forProduct(product.id, detail: true),
            ),
          ),
          if (product.availableColors.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: padding,
              child: Row(
                children: [
                  Text('Color: ', style: AppTypography.labelLarge),
                  if (selectedColor != null)
                    Text(selectedColor.name, style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: padding,
              child: Row(
                children: List.generate(product.availableColors.length, (i) {
                  final color = product.availableColors[i];
                  final isSelected = i == _selectedColorIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorIndex = i),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Color(color.colorValue),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: padding,
            child: Text(product.name, style: AppTypography.displaySmall),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: padding,
            child: Row(
              children: [
                PriceTag(price: product.price),
                const Spacer(),
                if (product.rating > 0)
                  RatingStars(
                    rating: product.rating,
                    size: 18,
                    reviewCount: product.reviewCount,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (product.styleTags.isNotEmpty)
            Padding(
              padding: padding,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: product.styleTags
                    .map(
                      (tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surfaceVariant,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    )
                    .toList(),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: padding,
            child: Text(product.description, style: AppTypography.bodyLarge),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: padding,
            child: _DetailSection(
              title: 'Dimensions',
              content: product.dimensions.formatted,
              icon: Icons.straighten,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: padding,
            child: _DetailSection(
              title: 'Materials',
              content: product.materials.join(', '),
              icon: Icons.layers,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: padding,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(
                    CartItem(
                      productId: product.id,
                      productName: product.name,
                      price: product.price,
                      selectedColor: selectedColor?.name,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () => context.push('/cart'),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text('Add to Cart'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: padding,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/room-studio'),
                    icon: const Icon(Icons.add_box_outlined, size: 20),
                    label: const Text('Add to Room'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'AR requires a compatible Android device with ARCore support.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.view_in_ar, size: 20),
                  label: const Text('View in AR'),
                ),
              ],
            ),
          ),
          if (product.modelPath != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: padding,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('3D viewer opened for this model.'),
                    ),
                  );
                },
                icon: const Icon(Icons.threed_rotation, size: 20),
                label: const Text('View in 3D'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sectionSpacing),
          if (reviews.isNotEmpty) ...[
            Padding(
              padding: padding,
              child: SectionHeader(title: 'Reviews (${reviews.length})'),
            ),
            const SizedBox(height: AppSpacing.md),
            ...reviews.map(
              (review) => Padding(
                padding: padding.copyWith(bottom: AppSpacing.md),
                child: _ReviewItem(
                  authorName: review.authorName,
                  rating: review.rating,
                  comment: review.comment,
                  date: review.date,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sectionSpacing),
          if (related.isNotEmpty) ...[
            Padding(
              padding: padding,
              child: const SectionHeader(title: 'Related Products'),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: padding,
                itemCount: related.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final relProduct = related[index];
                  return SizedBox(
                    width: 180,
                    child: FurnitureCard(
                      product: relProduct,
                      isFavorite: profile.favoriteProductIds.contains(
                        relProduct.id,
                      ),
                      onTap: () => context.push('/catalog/${relProduct.id}'),
                      onFavoriteToggle: () => ref
                          .read(userProfileProvider.notifier)
                          .toggleFavorite(relProduct.id),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          const CartIconButton(),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : null,
            ),
            onPressed: () => ref
                .read(userProfileProvider.notifier)
                .toggleFavorite(widget.productId),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _DetailSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.walnut),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(content, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String authorName;
  final double rating;
  final String comment;
  final DateTime date;

  const _ReviewItem({
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.beige,
                child: Text(
                  authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName, style: AppTypography.labelLarge),
                    Text(
                      DateFormat.yMMMd().format(date),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              RatingStars(rating: rating, size: 14),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(comment, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppConstants.seedDataLabel,
            style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
