import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/data/models/style.dart';

class StyleCard extends StatelessWidget {
  final InteriorStyle style;
  final VoidCallback? onTap;

  const StyleCard({super.key, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = Color(style.accentColor);
    final hsl = HSLColor.fromColor(accent);
    final darker = hsl
        .withLightness((hsl.lightness - 0.15).clamp(0.0, 0.9))
        .toColor();

    final imageUrl = ProductImages.forStyle(style.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          gradient: imageUrl == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, darker],
                )
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          image: imageUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    darker.withValues(alpha: 0.45),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Text(
              style.name,
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontFamily: 'Playfair Display',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: style.colorPalette.take(4).map((c) {
                return Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Color(c),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
