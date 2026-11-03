import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/application/providers/cart_providers.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/constants/product_images.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/core/widgets/empty_state_widget.dart';
import 'package:room_aura/core/widgets/price_tag.dart';
import 'package:room_aura/data/models/cart.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final itemCount = ref.watch(cartItemCountProvider);
    final padding = Responsive.screenPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart ($itemCount)'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 22),
              tooltip: 'Clear cart',
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              message:
                  'Browse the catalog and add furniture to your cart.',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: padding.copyWith(
                      top: AppSpacing.md,
                      bottom: AppSpacing.md,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _CartItemTile(item: items[index]),
                  ),
                ),
                _CartSummary(total: total, itemCount: itemCount),
              ],
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content:
            const Text('Remove all items from your cart? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(cartProvider.notifier).clear();
    }
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ProductImages.forProduct(item.productId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push('/catalog/${item.productId}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                width: 80,
                height: 80,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        errorWidget: (_, _, _) => _imageFallback(),
                      )
                    : _imageFallback(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.push('/catalog/${item.productId}'),
                  child: Text(
                    item.productName,
                    style: AppTypography.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.selectedColor != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.selectedColor!,
                    style: AppTypography.caption,
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                PriceTag(
                  price: item.price,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (item.quantity > 1) {
                          ref.read(cartProvider.notifier).updateQuantity(
                                item.productId,
                                item.quantity - 1,
                              );
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .removeItem(item.productId);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: AppTypography.labelLarge,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.productId,
                              item.quantity + 1,
                            );
                      },
                    ),
                    const Spacer(),
                    Text(
                      '${AppConstants.currencySymbol} ${NumberFormat('#,###').format(item.subtotal.round())}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.walnut,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: AppColors.silver),
            onPressed: () =>
                ref.read(cartProvider.notifier).removeItem(item.productId),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.weekend_outlined,
        color: AppColors.silver,
        size: 28,
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;
  final int itemCount;

  const _CartSummary({required this.total, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: const Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal ($itemCount items)',
                    style: AppTypography.bodyMedium),
                Text(
                  '${AppConstants.currencySymbol} ${NumberFormat('#,###').format(total.round())}',
                  style: AppTypography.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery', style: AppTypography.bodyMedium),
                Text('Calculated at checkout',
                    style: AppTypography.caption),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: AppTypography.headlineMedium),
                Text(
                  '${AppConstants.currencySymbol} ${NumberFormat('#,###').format(total.round())}',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.walnut,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showCheckoutDialog(context),
                child: const Text('Proceed to Checkout'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppConstants.seedDataLabel,
              style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text(
          'This is a demonstration app. In a production version, '
          'this would proceed to a secure payment flow with delivery options.\n\n'
          'All prices shown are in Ethiopian Birr (ETB) for demonstration purposes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
