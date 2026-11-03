import 'package:flutter/material.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int? reviewCount;
  final bool showNumber;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.reviewCount,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showNumber) ...[
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
        ],
        ...List.generate(5, (i) {
          final starValue = i + 1;
          IconData icon;
          if (rating >= starValue) {
            icon = Icons.star_rounded;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_outline_rounded;
          }
          return Icon(icon, size: size, color: const Color(0xFFD4A04A));
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text('($reviewCount)', style: AppTypography.caption),
        ],
      ],
    );
  }
}
