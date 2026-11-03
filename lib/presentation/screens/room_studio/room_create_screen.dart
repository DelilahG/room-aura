import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/application/providers/design_providers.dart';

const _roomTypes = [
  'Living Room',
  'Bedroom',
  'Kitchen',
  'Dining Room',
  'Home Office',
  'Bathroom',
  'Nursery',
  'Studio',
];

const _floorMaterials = [
  'Hardwood',
  'Tile',
  'Carpet',
  'Marble',
  'Concrete',
  'Laminate',
];

const _wallColors = [
  0xFFF5F0EB, // Ivory
  0xFFFAF7F2, // Cream
  0xFFE8DFD3, // Sand
  0xFFD4C5B2, // Beige
  0xFFA8B5A0, // Sage
  0xFFD6CFC4, // Warm gray
  0xFFE0D5C5, // Linen
  0xFFC9B99A, // Warm beige
  0xFFB8C4B8, // Muted green
  0xFF3A3A3A, // Charcoal
];

const _floorColors = [
  0xFFD4C5B2, // Light wood
  0xFFB09A7A, // Medium wood
  0xFF8B7355, // Walnut
  0xFF5C4A32, // Espresso
  0xFFC9B99A, // Light oak
  0xFFE8DFD3, // Birch
  0xFF9E8E7E, // Ash
  0xFF6B6B6B, // Concrete
];

class RoomCreateScreen extends ConsumerStatefulWidget {
  final String? designId;
  const RoomCreateScreen({super.key, this.designId});

  @override
  ConsumerState<RoomCreateScreen> createState() => _RoomCreateScreenState();
}

class _RoomCreateScreenState extends ConsumerState<RoomCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _roomType;
  late double _width;
  late double _length;
  late double _height;
  late int _wallColor;
  late int _floorColor;
  late String _floorMaterial;
  bool _isEditing = false;
  RoomDesign? _existingDesign;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roomType = _roomTypes.first;
    _width = AppConstants.defaultRoomWidth;
    _length = AppConstants.defaultRoomLength;
    _height = AppConstants.defaultRoomHeight;
    _wallColor = _wallColors.first;
    _floorColor = _floorColors.first;
    _floorMaterial = _floorMaterials.first;

    if (widget.designId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExisting();
      });
    }
  }

  void _loadExisting() {
    final designs = ref.read(allDesignsProvider);
    final found = designs.where((d) => d.id == widget.designId).toList();
    if (found.isNotEmpty) {
      final d = found.first;
      setState(() {
        _isEditing = true;
        _existingDesign = d;
        _nameController.text = d.name;
        _roomType = d.roomType;
        _width = d.width;
        _length = d.length;
        _height = d.height;
        _wallColor = d.wallColor;
        _floorColor = d.floorColor;
        _floorMaterial = d.floorMaterial;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Room' : 'Create Room'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Room Details', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Room Name',
                      hintText: 'e.g. My Living Room',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _roomType,
                    decoration: const InputDecoration(labelText: 'Room Type'),
                    items: _roomTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _roomType = v ?? _roomType),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  Text('Dimensions', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  _buildDimensionSlider(
                    'Width',
                    _width,
                    AppConstants.minRoomWidth,
                    AppConstants.maxRoomWidth,
                    (v) => setState(() => _width = v),
                  ),
                  _buildDimensionSlider(
                    'Length',
                    _length,
                    AppConstants.minRoomLength,
                    AppConstants.maxRoomLength,
                    (v) => setState(() => _length = v),
                  ),
                  _buildDimensionSlider(
                    'Height',
                    _height,
                    AppConstants.minRoomHeight,
                    AppConstants.maxRoomHeight,
                    (v) => setState(() => _height = v),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  Text('Wall Color', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  _buildColorGrid(
                    _wallColors,
                    _wallColor,
                    (c) => setState(() => _wallColor = c),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  Text('Floor', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _floorMaterial,
                    decoration: const InputDecoration(
                      labelText: 'Floor Material',
                    ),
                    items: _floorMaterials
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _floorMaterial = v ?? _floorMaterial),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildColorGrid(
                    _floorColors,
                    _floorColor,
                    (c) => setState(() => _floorColor = c),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _buildPreview(),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isEditing ? 'Update Room' : 'Create Room'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.labelLarge),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  '${value.toStringAsFixed(1)} m',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 10).round(),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.divider,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildColorGrid(
    List<int> colors,
    int selected,
    ValueChanged<int> onTap,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: colors.map((c) {
        final isSelected = c == selected;
        return GestureDetector(
          onTap: () => onTap(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(c),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    color: _contrastColor(Color(c)),
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Color _contrastColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? AppColors.charcoal : Colors.white;
  }

  Widget _buildPreview() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Color(_floorColor),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(_wallColor), width: 6),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_width.toStringAsFixed(1)}m × ${_length.toStringAsFixed(1)}m',
                  style: AppTypography.headlineMedium.copyWith(
                    color: _contrastColor(Color(_floorColor)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_roomType · $_floorMaterial',
                  style: AppTypography.bodySmall.copyWith(
                    color: _contrastColor(Color(_floorColor))
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final design = _isEditing && _existingDesign != null
        ? _existingDesign!.copyWith(
            name: _nameController.text.trim(),
            roomType: _roomType,
            width: _width,
            length: _length,
            height: _height,
            wallColor: _wallColor,
            floorColor: _floorColor,
            floorMaterial: _floorMaterial,
            updatedAt: now,
          )
        : RoomDesign(
            id: const Uuid().v4(),
            name: _nameController.text.trim(),
            roomType: _roomType,
            width: _width,
            length: _length,
            height: _height,
            wallColor: _wallColor,
            floorColor: _floorColor,
            floorMaterial: _floorMaterial,
            createdAt: now,
            updatedAt: now,
            isDraft: true,
          );

    ref.read(allDesignsProvider.notifier).save(design);
    context.go('/room-studio/edit/${design.id}');
  }
}
