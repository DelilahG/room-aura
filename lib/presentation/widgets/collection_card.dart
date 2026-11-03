import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/data/models/collection.dart';

class CollectionCard extends StatelessWidget {
  final DesignCollection collection;
  final VoidCallback? onTap;

  const CollectionCard({super.key, required this.collection, this.onTap});

  @override
  Widget build(BuildContext context) {
    final baseColor = Color(collection.coverColor);
    final hsl = HSLColor.fromColor(baseColor);
    final lighter = hsl
        .withLightness((hsl.lightness + 0.12).clamp(0.0, 0.95))
        .toColor();

    final imageUrl = ProductImages.forCollection(collection.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: imageUrl == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [lighter, baseColor],
                )
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          image: imageUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    baseColor.withValues(alpha: 0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Text(
              collection.name,
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontFamily: 'Playfair Display',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              collection.description,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${collection.productIds.length} items',
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
