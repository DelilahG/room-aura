import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/core/theme/app_spacing.dart';
import 'package:room_aura/core/widgets/empty_state_widget.dart';
import 'package:room_aura/presentation/widgets/furniture_list_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final q = GoRouterState.of(context).uri.queryParameters['q'];
      if (q != null && q.isNotEmpty) {
        _controller.text = q;
        ref.read(searchQueryProvider.notifier).state = q;
        setState(() => _showSuggestions = false);
      } else {
        final existing = ref.read(searchQueryProvider);
        if (existing.isNotEmpty) {
          _controller.text = existing;
        }
      }
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectSuggestion(SearchSuggestion suggestion) {
    if (suggestion.productId != null) {
      context.push('/catalog/${suggestion.productId}');
      return;
    }
    _controller.text = suggestion.text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.text.length),
    );
    ref.read(searchQueryProvider.notifier).state = suggestion.text;
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final suggestions = ref.watch(searchSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            context.pop();
          },
        ),
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search furniture, styles, materials...',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
          style: AppTypography.bodyLarge,
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            if (!_showSuggestions) {
              setState(() => _showSuggestions = true);
            }
          },
          onSubmitted: (_) {
            setState(() => _showSuggestions = false);
          },
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
                setState(() => _showSuggestions = true);
              },
            ),
        ],
      ),
      body: _buildBody(context, ref, query, results, suggestions),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    String query,
    List results,
    List<SearchSuggestion> suggestions,
  ) {
    if (query.isEmpty) {
      return _buildPopularSearches(context, ref);
    }

    if (_showSuggestions && suggestions.isNotEmpty) {
      return _buildSuggestionsList(context, ref, suggestions);
    }

    if (results.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '${results.length} result${results.length == 1 ? '' : 's'}',
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.pageInsets,
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = results[index];
                return FurnitureListTile(
                  product: product,
                  onTap: () => context.push('/catalog/${product.id}'),
                );
              },
            ),
          ),
        ],
      );
    }

    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results',
      message: 'No products match "$query". Try a different search term.',
    );
  }

  Widget _buildPopularSearches(BuildContext context, WidgetRef ref) {
    const popular = [
      'Sofa',
      'Scandinavian',
      'Oak',
      'Pendant Light',
      'Dining Table',
      'Bohemian',
      'Rug',
      'Minimalist',
      'Walnut',
      'Bookshelf',
    ];

    return ListView(
      padding: AppSpacing.pageInsets.copyWith(top: AppSpacing.lg),
      children: [
        Text('Popular Searches', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: popular.map((term) {
            return ActionChip(
              label: Text(term),
              avatar: const Icon(Icons.trending_up, size: 16),
              onPressed: () {
                _controller.text = term;
                ref.read(searchQueryProvider.notifier).state = term;
                setState(() => _showSuggestions = false);
              },
              backgroundColor: AppColors.surfaceVariant,
              side: BorderSide.none,
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Browse by Category', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.md),
        ...ref.read(categoriesProvider).map((cat) {
          return ListTile(
            leading: Icon(
              _iconForCategory(cat.name),
              color: AppColors.walnut,
              size: 22,
            ),
            title: Text(cat.name, style: AppTypography.bodyMedium),
            trailing: Text('${cat.productCount}', style: AppTypography.caption),
            dense: true,
            contentPadding: EdgeInsets.zero,
            onTap: () {
              _controller.text = cat.name;
              ref.read(searchQueryProvider.notifier).state = cat.name;
              setState(() => _showSuggestions = false);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSuggestionsList(
    BuildContext context,
    WidgetRef ref,
    List<SearchSuggestion> suggestions,
  ) {
    return ListView.builder(
      padding: AppSpacing.pageInsets.copyWith(top: AppSpacing.sm),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final s = suggestions[index];
        return ListTile(
          leading: Icon(
            _iconForSuggestionType(s.type),
            color: AppColors.walnut,
            size: 20,
          ),
          title: Text(s.text, style: AppTypography.bodyMedium),
          subtitle: Text(
            _labelForType(s.type, s.count),
            style: AppTypography.caption,
          ),
          trailing: const Icon(
            Icons.north_west,
            size: 16,
            color: AppColors.silver,
          ),
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          onTap: () => _selectSuggestion(s),
        );
      },
    );
  }

  static IconData _iconForSuggestionType(SuggestionType type) {
    return switch (type) {
      SuggestionType.category => Icons.category_outlined,
      SuggestionType.style => Icons.palette_outlined,
      SuggestionType.material => Icons.texture,
      SuggestionType.product => Icons.weekend_outlined,
    };
  }

  static String _labelForType(SuggestionType type, int? count) {
    final suffix = count != null ? ' ($count items)' : '';
    return switch (type) {
      SuggestionType.category => 'Category$suffix',
      SuggestionType.style => 'Interior Style',
      SuggestionType.material => 'Material',
      SuggestionType.product => 'Product',
    };
  }

  static IconData _iconForCategory(String name) {
    return switch (name.toLowerCase()) {
      'sofas' => Icons.weekend_outlined,
      'beds' => Icons.bed_outlined,
      'chairs' => Icons.chair_outlined,
      'tables' => Icons.table_restaurant_outlined,
      'storage' => Icons.inventory_2_outlined,
      'lighting' => Icons.lightbulb_outline,
      'rugs' => Icons.rectangle_outlined,
      'decor' => Icons.spa_outlined,
      'cabinets' => Icons.kitchen_outlined,
      'outdoor' => Icons.deck_outlined,
      _ => Icons.category_outlined,
    };
  }
}
