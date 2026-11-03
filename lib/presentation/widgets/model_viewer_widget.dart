import 'package:flutter/material.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/widgets/product_image_placeholder.dart';

class ModelViewerWidget extends StatefulWidget {
  final String? modelPath;
  final String productName;
  final int fallbackColor;
  final String category;
  final String? productId;

  const ModelViewerWidget({
    super.key,
    this.modelPath,
    required this.productName,
    required this.fallbackColor,
    required this.category,
    this.productId,
  });

  @override
  State<ModelViewerWidget> createState() => _ModelViewerWidgetState();
}

class _ModelViewerWidgetState extends State<ModelViewerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateHintController;

  @override
  void initState() {
    super.initState();
    _rotateHintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateHintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ProductImagePlaceholder(
          category: widget.category,
          colorValue: widget.fallbackColor,
          imageUrl: widget.productId != null
              ? ProductImages.forProduct(widget.productId!)
              : null,
        ),
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.md,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.charcoal.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.view_in_ar, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '3D',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _rotateHintController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateHintController.value * 6.28,
                    child: child,
                  );
                },
                child: Icon(
                  Icons.threed_rotation,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  widget.modelPath != null
                      ? '3D model available'
                      : '3D preview',
                  style: AppTypography.labelSmall.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
