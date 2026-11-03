import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/data/models/furniture.dart';
import 'package:room_aura/application/providers/design_providers.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/presentation/widgets/room_editor_canvas.dart';
import 'package:room_aura/data/seed/categories_seed.dart';

class RoomEditorScreen extends ConsumerStatefulWidget {
  final String designId;
  const RoomEditorScreen({super.key, required this.designId});

  @override
  ConsumerState<RoomEditorScreen> createState() => _RoomEditorScreenState();
}

class _RoomEditorScreenState extends ConsumerState<RoomEditorScreen>
    with SingleTickerProviderStateMixin {
  RoomDesign? _design;
  String? _selectedFurnitureId;
  bool _showCatalog = false;
  late TabController _tabController;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: SeedCategories.all.length,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDesign());
  }

  void _loadDesign() {
    final designs = ref.read(allDesignsProvider);
    final found = designs.where((d) => d.id == widget.designId).toList();
    if (found.isNotEmpty) {
      setState(() => _design = found.first);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_design == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Room Editor')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final design = _design!;
    final allProducts = ref.watch(allProductsProvider);
    final selectedPiece = _selectedFurnitureId != null
        ? design.furniture.where((f) => f.id == _selectedFurnitureId).toList()
        : <PlacedFurniture>[];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (_hasUnsavedChanges) _save();
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          title: Text(design.name, style: AppTypography.headlineSmall),
          backgroundColor: Colors.white,
          actions: [
            if (_hasUnsavedChanges)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.circle, size: 8, color: AppColors.warning),
              ),
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: _save,
            ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Room Settings'),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Text('Duplicate'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  RoomEditorCanvas(
                    roomDesign: design,
                    selectedFurnitureId: _selectedFurnitureId,
                    onFurnitureMoved: (id, x, y) {
                      setState(() {
                        _design = design.copyWith(
                          furniture: design.furniture.map((f) {
                            if (f.id == id) return f.copyWith(x: x, y: y);
                            return f;
                          }).toList(),
                        );
                        _hasUnsavedChanges = true;
                      });
                    },
                    onFurnitureSelected: (id) {
                      setState(() => _selectedFurnitureId = id);
                    },
                    onFurnitureRotated: (id, rotation) {
                      setState(() {
                        _design = design.copyWith(
                          furniture: design.furniture.map((f) {
                            if (f.id == id) {
                              return f.copyWith(rotation: rotation);
                            }
                            return f;
                          }).toList(),
                        );
                        _hasUnsavedChanges = true;
                      });
                    },
                    onFurnitureRemoved: (id) => _removeFurniture(id),
                  ),
                  if (_selectedFurnitureId == null && !_showCatalog)
                    Positioned(
                      bottom: AppSpacing.md,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.charcoal.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Text(
                            'Tap furniture to select · Drag to move · Use + to add',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '${design.width.toStringAsFixed(1)}m × ${design.length.toStringAsFixed(1)}m · ${design.furniture.length} items',
                        style: AppTypography.labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedPiece.isNotEmpty)
              _buildPropertiesPanel(selectedPiece.first),
            if (_showCatalog) _buildCatalogPanel(allProducts),
          ],
        ),
        floatingActionButton: !_showCatalog && selectedPiece.isEmpty
            ? FloatingActionButton(
                onPressed: () => setState(() => _showCatalog = true),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnDark,
                child: const Icon(Icons.add_rounded),
              )
            : null,
      ),
    );
  }

  Widget _buildPropertiesPanel(PlacedFurniture piece) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(piece.name, style: AppTypography.headlineSmall),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _selectedFurnitureId = null),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text('Position: ', style: AppTypography.labelMedium),
                Text(
                  '(${piece.x.toStringAsFixed(1)}, ${piece.y.toStringAsFixed(1)}) m',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(width: AppSpacing.md),
                Text('Size: ', style: AppTypography.labelMedium),
                Text(
                  '${piece.width.toStringAsFixed(1)} × ${piece.depth.toStringAsFixed(1)} m',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text('Rotation', style: AppTypography.labelMedium),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Slider(
                    value: piece.rotation,
                    min: 0,
                    max: 360,
                    divisions: 72,
                    activeColor: AppColors.primary,
                    label: '${piece.rotation.round()}°',
                    onChanged: (v) {
                      setState(() {
                        _design = _design!.copyWith(
                          furniture: _design!.furniture.map((f) {
                            if (f.id == piece.id) {
                              return f.copyWith(rotation: v);
                            }
                            return f;
                          }).toList(),
                        );
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                ),
                Text(
                  '${piece.rotation.round()}°',
                  style: AppTypography.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _removeFurniture(piece.id),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _duplicateFurniture(piece),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Duplicate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogPanel(List<FurnitureProduct> products) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.sm,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Furniture',
                    style: AppTypography.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _showCatalog = false),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            tabAlignment: TabAlignment.start,
            tabs: SeedCategories.all.map((c) => Tab(text: c.name)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: SeedCategories.all.map((cat) {
                final catProducts = products
                    .where(
                      (p) => p.category.toLowerCase() == cat.id.toLowerCase(),
                    )
                    .toList();
                if (catProducts.isEmpty) {
                  return Center(
                    child: Text(
                      'No items in this category',
                      style: AppTypography.bodySmall,
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: catProducts.length,
                  itemBuilder: (context, index) {
                    final p = catProducts[index];
                    return _buildCatalogItem(p);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogItem(FurnitureProduct product) {
    final color = product.availableColors.isNotEmpty
        ? Color(product.availableColors.first.colorValue)
        : AppColors.walnut;

    return GestureDetector(
      onTap: () => _addFurniture(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                _categoryIcon(product.category),
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                product.name,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'sofas' => Icons.weekend_outlined,
      'beds' => Icons.bed_outlined,
      'chairs' => Icons.chair_outlined,
      'tables' => Icons.table_restaurant_outlined,
      'storage' => Icons.inventory_2_outlined,
      'lighting' => Icons.light_outlined,
      'rugs' => Icons.rectangle_outlined,
      'decor' => Icons.palette_outlined,
      'cabinets' => Icons.kitchen_outlined,
      'outdoor' => Icons.deck_outlined,
      _ => Icons.category_outlined,
    };
  }

  void _addFurniture(FurnitureProduct product) {
    final id = const Uuid().v4();
    final widthM = product.dimensions.width / 100;
    final depthM = product.dimensions.depth / 100;
    final color = product.availableColors.isNotEmpty
        ? product.availableColors.first.colorValue
        : 0xFF8B7355;

    final placed = PlacedFurniture(
      id: id,
      furnitureId: product.id,
      name: product.name,
      x: _design!.width / 2 - widthM / 2,
      y: _design!.length / 2 - depthM / 2,
      width: widthM,
      depth: depthM,
      color: color,
      material: product.materials.isNotEmpty ? product.materials.first : null,
    );

    setState(() {
      _design = _design!.copyWith(furniture: [..._design!.furniture, placed]);
      _selectedFurnitureId = id;
      _showCatalog = false;
      _hasUnsavedChanges = true;
    });
  }

  void _removeFurniture(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Furniture'),
        content: const Text('Remove this item from the room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        _design = _design!.copyWith(
          furniture: _design!.furniture.where((f) => f.id != id).toList(),
        );
        if (_selectedFurnitureId == id) _selectedFurnitureId = null;
        _hasUnsavedChanges = true;
      });
    }
  }

  void _duplicateFurniture(PlacedFurniture piece) {
    final newId = const Uuid().v4();
    final dup = PlacedFurniture(
      id: newId,
      furnitureId: piece.furnitureId,
      name: piece.name,
      x: (piece.x + 0.3).clamp(0, _design!.width - piece.width),
      y: (piece.y + 0.3).clamp(0, _design!.length - piece.depth),
      width: piece.width,
      depth: piece.depth,
      rotation: piece.rotation,
      color: piece.color,
      material: piece.material,
    );
    setState(() {
      _design = _design!.copyWith(furniture: [..._design!.furniture, dup]);
      _selectedFurnitureId = newId;
      _hasUnsavedChanges = true;
    });
  }

  void _save() {
    if (_design != null) {
      ref
          .read(allDesignsProvider.notifier)
          .save(_design!.copyWith(updatedAt: DateTime.now()));
      setState(() => _hasUnsavedChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Design saved'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'rename':
        final controller = TextEditingController(text: _design!.name);
        final name = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Rename Room'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                child: const Text('Rename'),
              ),
            ],
          ),
        );
        if (name != null && name.isNotEmpty) {
          setState(() {
            _design = _design!.copyWith(name: name);
            _hasUnsavedChanges = true;
          });
        }
      case 'settings':
        context.go('/room-studio/new?editId=${_design!.id}');
      case 'duplicate':
        ref.read(allDesignsProvider.notifier).duplicate(_design!.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Design duplicated')));
        }
      case 'delete':
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed == true && mounted) {
          ref.read(allDesignsProvider.notifier).delete(_design!.id);
          context.go('/room-studio');
        }
    }
  }
}
