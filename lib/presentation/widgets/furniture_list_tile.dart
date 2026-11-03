import 'package:flutter/material.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/widgets/product_image_placeholder.dart';
import 'package:room_aura/core/widgets/price_tag.dart';
import 'package:room_aura/data/models/furniture.dart';

class FurnitureListTile extends StatelessWidget {
  final FurnitureProduct product;
  final VoidCallback? onTap;

  const FurnitureListTile({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = product.availableColors.isNotEmpty
        ? product.availableColors.first.colorValue
        : 0xFF8B7355;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                width: 64,
                height: 64,
                child: ProductImagePlaceholder(
                  category: product.category,
                  colorValue: primaryColor,
                  imageUrl: ProductImages.forProduct(product.id),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(product.category, style: AppTypography.caption),
                ],
              ),
            ),
            PriceTag(
              price: product.price,
              style: AppTypography.price.copyWith(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: AppColors.silver),
          ],
        ),
      ),
    );
  }
}
