import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';

class ArScreen extends StatelessWidget {
  final String? productId;
  const ArScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Augmented Reality')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: kIsWeb
                ? _buildWebContent(context)
                : _buildAndroidContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildWebContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.view_in_ar_rounded,
            size: 56,
            color: AppColors.deepSage,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Augmented Reality',
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'AR requires a compatible Android device with ARCore support. '
          'This feature uses your device camera to place furniture in your real space.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Use the 3D Room Studio for an interactive design experience in your browser.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/room-studio'),
            icon: const Icon(Icons.dashboard_customize_outlined),
            label: const Text('Open Room Studio'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/explore'),
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Explore Furniture'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildRequirements(),
      ],
    );
  }

  Widget _buildAndroidContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.view_in_ar_rounded,
            size: 56,
            color: AppColors.deepSage,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'AR Preview',
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.construction_rounded,
                color: AppColors.warning,
                size: 32,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'AR Feature — Coming Soon',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'AR integration requires a physical Android device with ARCore support. '
                'This feature is scaffolded for future ARCore implementation and has not '
                'been tested on a physical device.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/room-studio'),
            icon: const Icon(Icons.dashboard_customize_outlined),
            label: const Text('Use Room Studio Instead'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildRequirements(),
      ],
    );
  }

  Widget _buildRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AR Requirements', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        _requirementRow(
          Icons.phone_android,
          'Android device with ARCore support',
        ),
        _requirementRow(Icons.camera_alt_outlined, 'Camera permission'),
        _requirementRow(Icons.light_mode_outlined, 'Well-lit environment'),
        _requirementRow(
          Icons.square_foot_outlined,
          'Flat surface for placement',
        ),
      ],
    );
  }

  Widget _requirementRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}
