import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/widgets/section_header.dart';
import 'package:room_aura/core/widgets/empty_state_widget.dart';
import 'package:room_aura/application/providers/design_providers.dart';
import 'package:room_aura/data/seed/templates_seed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_aura/presentation/widgets/design_card.dart';
import 'package:room_aura/presentation/widgets/template_card.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:uuid/uuid.dart';

class RoomStudioScreen extends ConsumerWidget {
  const RoomStudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designs = ref.watch(allDesignsProvider);
    final templates = SeedTemplates.all;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Room Studio',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create New Room',
            onPressed: () => context.go('/room-studio/new'),
          ),
        ],
      ),
      body: ListView(
        padding: Responsive.screenPadding(context)
            .copyWith(top: AppSpacing.md, bottom: 100),
        children: [
          _buildCreateBanner(context),
          const SizedBox(height: AppSpacing.sectionSpacing),
          const SectionHeader(title: 'Room Templates'),
          const SizedBox(height: AppSpacing.itemSpacing),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: templates.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.itemSpacing),
              itemBuilder: (context, index) {
                final t = templates[index];
                return SizedBox(
                  width: 200,
                  child: TemplateCard(
                    template: t,
                    onTap: () => _createFromTemplate(context, ref, t),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          SectionHeader(title: 'Your Rooms (${designs.length})'),
          const SizedBox(height: AppSpacing.itemSpacing),
          if (designs.isEmpty)
            const EmptyStateWidget(
              icon: Icons.dashboard_customize_outlined,
              title: 'Start designing your perfect room',
              message: 'Create a new room or choose a template above to get started.',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.gridCrossAxisCount(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                ),
                childAspectRatio: isMobile ? 1.6 : 1.4,
                crossAxisSpacing: AppSpacing.itemSpacing,
                mainAxisSpacing: AppSpacing.itemSpacing,
              ),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final d = designs[index];
                return DesignCard(
                  design: d,
                  onTap: () => context.go('/room-studio/edit/${d.id}'),
                  onDelete: () => _deleteDesign(context, ref, d.id),
                  onDuplicate: () =>
                      ref.read(allDesignsProvider.notifier).duplicate(d.id),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/room-studio/new'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Room'),
      ),
    );
  }

  Widget _buildCreateBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(ProductImages.studioBanner),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xBB3D2E1A), BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Your Space',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.cream,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create custom room layouts, place furniture, and bring your vision to life.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.sand),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () => context.go('/room-studio/new'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cream,
              foregroundColor: AppColors.espresso,
            ),
            child: const Text('Create New Room'),
          ),
        ],
      ),
    );
  }

  void _createFromTemplate(
    BuildContext context,
    WidgetRef ref,
    RoomTemplate template,
  ) {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final design = RoomDesign(
      id: id,
      name: '${template.name} Design',
      roomType: template.roomType,
      width: template.width,
      length: template.length,
      height: template.height,
      wallColor: template.wallColor,
      floorColor: template.floorColor,
      floorMaterial: template.floorMaterial,
      furniture: template.suggestedFurniture,
      createdAt: now,
      updatedAt: now,
      isDraft: true,
      templateId: template.id,
    );
    ref.read(allDesignsProvider.notifier).save(design);
    context.go('/room-studio/edit/$id');
  }

  Future<void> _deleteDesign(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Design'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(allDesignsProvider.notifier).delete(id);
    }
  }
}
