import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/data/models/room.dart';

class TemplateCard extends StatelessWidget {
  final RoomTemplate template;
  final VoidCallback? onTap;

  const TemplateCard({super.key, required this.template, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _TemplateImage(template: template)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${template.roomType} · ${template.style}',
                    style: AppTypography.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateImage extends StatelessWidget {
  final RoomTemplate template;

  const _TemplateImage({required this.template});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ProductImages.forTemplate(template.id);

    if (imageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => _fallback(),
            errorWidget: (context, url, error) => _fallback(),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${template.width.toStringAsFixed(1)} x ${template.length.toStringAsFixed(1)} m',
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Container(
      color: Color(template.floorColor).withValues(alpha: 0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForRoomType(template.roomType),
              size: 36,
              color: AppColors.walnut.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              '${template.width.toStringAsFixed(1)} x ${template.length.toStringAsFixed(1)} m',
              style: AppTypography.caption.copyWith(color: AppColors.walnut),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _iconForRoomType(String roomType) {
    return switch (roomType.toLowerCase()) {
      'living room' => Icons.weekend_outlined,
      'bedroom' => Icons.bed_outlined,
      'kitchen' => Icons.kitchen_outlined,
      'dining room' => Icons.table_restaurant_outlined,
      'bathroom' => Icons.bathtub_outlined,
      'office' || 'home office' => Icons.desk_outlined,
      'kids room' => Icons.child_care_outlined,
      _ => Icons.home_outlined,
    };
  }
}
