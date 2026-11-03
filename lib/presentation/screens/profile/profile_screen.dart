import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/application/providers/user_providers.dart';
import 'package:room_aura/application/providers/design_providers.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:room_aura/core/widgets/confirmation_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final styles = ref.watch(stylesProvider);
    final favorites = ref.watch(favoriteProductsProvider);

    final initials = profile.displayName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Avatar + name
          Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.sand,
                child: Text(
                  initials,
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.espresso,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(profile.displayName, style: AppTypography.headlineLarge),
              const SizedBox(height: 4),
              Text(profile.email, style: AppTypography.bodySmall),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Demo account banner
          Container(
            margin: AppSpacing.pageInsets,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.info),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppConstants.demoAccountLabel,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Edit profile
          _SectionTitle(title: 'Account'),
          _ActionTile(
            icon: Icons.edit_outlined,
            label: 'Edit Name',
            subtitle: profile.displayName,
            onTap: () => _editField(
              context,
              ref,
              title: 'Display Name',
              initial: profile.displayName,
              onSave: (v) =>
                  ref.read(userProfileProvider.notifier).updateDisplayName(v),
            ),
          ),
          _ActionTile(
            icon: Icons.email_outlined,
            label: 'Edit Email',
            subtitle: profile.email,
            onTap: () => _editField(
              context,
              ref,
              title: 'Email',
              initial: profile.email,
              onSave: (v) =>
                  ref.read(userProfileProvider.notifier).updateEmail(v),
            ),
          ),

          const Divider(height: 32),

          // Preferences
          _SectionTitle(title: 'Preferences'),
          Padding(
            padding: AppSpacing.pageInsets,
            child: DropdownButtonFormField<String>(
              initialValue: profile.preferredStyle.isEmpty
                  ? null
                  : profile.preferredStyle,
              decoration: const InputDecoration(
                labelText: 'Preferred Style',
                prefixIcon: Icon(Icons.palette_outlined),
              ),
              items: [
                const DropdownMenuItem(value: '', child: Text('No preference')),
                ...styles.map(
                  (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                ),
              ],
              onChanged: (v) => ref
                  .read(userProfileProvider.notifier)
                  .updatePreferredStyle(v ?? ''),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Favorites shortcut
          _ActionTile(
            icon: Icons.favorite_outline,
            label: 'Favorites',
            subtitle: '${favorites.length} items',
            onTap: () => context.push('/favorites'),
          ),

          const Divider(height: 32),

          // Data
          _SectionTitle(title: 'Data'),
          _ActionTile(
            icon: Icons.refresh,
            label: 'Reset Demo Data',
            subtitle:
                'Restores sample data. Your personal designs are preserved.',
            onTap: () async {
              final confirmed = await showConfirmationDialog(
                context,
                title: 'Reset Demo Data?',
                message: 'This will reset sample data to defaults. Your personal room designs will be preserved.',
                confirmLabel: 'Reset',
                isDestructive: true,
              );
              if (confirmed) {
                await ref.read(userProfileProvider.notifier).resetDemoData();
                await ref.read(allDesignsProvider.notifier).resetSeedDesigns();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demo data has been reset.')),
                  );
                }
              }
            },
          ),

          const Divider(height: 32),

          // About
          _SectionTitle(title: 'About'),
          Padding(
            padding: AppSpacing.pageInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Aura v${AppConstants.version}',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(AppConstants.tagline, style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                Text(AppConstants.seedDataLabel, style: AppTypography.caption),
              ],
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Future<void> _editField(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String initial,
    required Future<void> Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.isNotEmpty) {
      await onSave(result);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(title, style: AppTypography.headlineSmall),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.walnut),
      title: Text(label, style: AppTypography.bodyMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.silver,
      ),
      onTap: onTap,
    );
  }
}
