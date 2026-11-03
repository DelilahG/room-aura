import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/utils/responsive.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/presentation/widgets/style_card.dart';
import 'package:room_aura/presentation/widgets/room_card.dart';
import 'package:room_aura/presentation/widgets/collection_card.dart';
import 'package:room_aura/data/models/style.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String? _selectedRoomType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = ref.watch(stylesProvider);
    final inspirations = ref.watch(inspirationRoomsProvider);
    final collections = ref.watch(collectionsProvider);
    final padding = Responsive.screenPadding(context);

    final roomTypes = <String>{
      'All',
      ...inspirations.map((r) => r.roomType),
    }.toList();
    final filteredRooms =
        _selectedRoomType == null || _selectedRoomType == 'All'
        ? inspirations
        : inspirations.where((r) => r.roomType == _selectedRoomType).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Styles'),
            Tab(text: 'Inspiration'),
            Tab(text: 'Collections'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StylesTab(styles: styles, padding: padding),
          _InspirationTab(
            rooms: filteredRooms,
            roomTypes: roomTypes,
            selectedType: _selectedRoomType ?? 'All',
            onTypeSelected: (type) => setState(() {
              _selectedRoomType = type == 'All' ? null : type;
            }),
            padding: padding,
          ),
          _CollectionsTab(collections: collections, padding: padding),
        ],
      ),
    );
  }
}

class _StylesTab extends StatelessWidget {
  final List<InteriorStyle> styles;
  final EdgeInsets padding;

  const _StylesTab({required this.styles, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (styles.isEmpty) {
      return const Center(child: Text('No styles available'));
    }
    final crossCount = Responsive.gridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
    return GridView.builder(
      padding: padding.copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: styles.length,
      itemBuilder: (context, index) {
        final style = styles[index];
        return StyleCard(
          style: style,
          onTap: () => context.push('/explore/style/${style.id}'),
        );
      },
    );
  }
}

class _InspirationTab extends StatelessWidget {
  final List<InspirationRoom> rooms;
  final List<String> roomTypes;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;
  final EdgeInsets padding;

  const _InspirationTab({
    required this.rooms,
    required this.roomTypes,
    required this.selectedType,
    required this.onTypeSelected,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final crossCount = Responsive.gridCrossAxisCount(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: padding,
            itemCount: roomTypes.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final type = roomTypes[index];
              final isSelected = type == selectedType;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (_) => onTypeSelected(type),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.textOnDark
                      : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: rooms.isEmpty
              ? Center(
                  child: Text(
                    'No rooms found',
                    style: AppTypography.bodyMedium,
                  ),
                )
              : GridView.builder(
                  padding: padding.copyWith(bottom: AppSpacing.xxl),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return RoomCard(
                      room: room,
                      onTap: () => context.push('/explore'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CollectionsTab extends StatelessWidget {
  final List collections;
  final EdgeInsets padding;

  const _CollectionsTab({required this.collections, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return const Center(child: Text('No collections available'));
    }
    return ListView.separated(
      padding: padding.copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
      itemCount: collections.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final collection = collections[index];
        return SizedBox(
          height: 140,
          child: CollectionCard(
            collection: collection,
            onTap: () => context.push('/explore'),
          ),
        );
      },
    );
  }
}
