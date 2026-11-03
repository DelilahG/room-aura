import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_aura/data/models/furniture.dart';
import 'package:room_aura/data/models/style.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/data/models/collection.dart';
import 'package:room_aura/data/models/review.dart';
import 'package:room_aura/data/repositories/furniture_repository.dart';

final furnitureRepositoryProvider = Provider<FurnitureRepository>(
  (ref) => FurnitureRepository(),
);

final allProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  return ref.read(furnitureRepositoryProvider).getAllProducts();
});

final categoriesProvider = Provider<List<FurnitureCategory>>((ref) {
  return ref.read(furnitureRepositoryProvider).getCategories();
});

final stylesProvider = Provider<List<InteriorStyle>>((ref) {
  return ref.read(furnitureRepositoryProvider).getStyles();
});

final featuredProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  return ref.read(furnitureRepositoryProvider).getFeatured();
});

final newProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  return ref.read(furnitureRepositoryProvider).getNew();
});

final inspirationRoomsProvider = Provider<List<InspirationRoom>>((ref) {
  return ref.read(furnitureRepositoryProvider).getInspirationRooms();
});

final templatesProvider = Provider<List<RoomTemplate>>((ref) {
  return ref.read(furnitureRepositoryProvider).getTemplates();
});

final collectionsProvider = Provider<List<DesignCollection>>((ref) {
  return ref.read(furnitureRepositoryProvider).getCollections();
});

final productDetailProvider = Provider.family<FurnitureProduct?, String>((
  ref,
  id,
) {
  return ref.read(furnitureRepositoryProvider).getById(id);
});

final productReviewsProvider = Provider.family<List<ProductReview>, String>((
  ref,
  productId,
) {
  return ref.read(furnitureRepositoryProvider).getReviewsForProduct(productId);
});

final relatedProductsProvider = Provider.family<List<FurnitureProduct>, String>(
  (ref, productId) {
    return ref.read(furnitureRepositoryProvider).getRelated(productId);
  },
);

final categoryProductsProvider =
    Provider.family<List<FurnitureProduct>, String>((ref, category) {
      return ref.read(furnitureRepositoryProvider).getByCategory(category);
    });

// --- Search and filter state ---

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final selectedStyleProvider = StateProvider<String?>((ref) => null);

final minPriceProvider = StateProvider<double?>((ref) => null);

final maxPriceProvider = StateProvider<double?>((ref) => null);

final sortByProvider = StateProvider<String>((ref) => 'name');

final filteredProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final style = ref.watch(selectedStyleProvider);
  final minPrice = ref.watch(minPriceProvider);
  final maxPrice = ref.watch(maxPriceProvider);
  final sortBy = ref.watch(sortByProvider);

  return ref
      .read(furnitureRepositoryProvider)
      .filter(
        category: category,
        style: style,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
      );
});

final searchResultsProvider = Provider<List<FurnitureProduct>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(furnitureRepositoryProvider).search(query);
});

final searchSuggestionsProvider = Provider<List<SearchSuggestion>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.length < 2) return [];

  final repo = ref.read(furnitureRepositoryProvider);
  final products = repo.getAllProducts();
  final categories = repo.getCategories();
  final styles = repo.getStyles();

  final seen = <String>{};
  final suggestions = <SearchSuggestion>[];

  for (final cat in categories) {
    if (cat.name.toLowerCase().contains(query) && seen.add(cat.name)) {
      suggestions.add(
        SearchSuggestion(
          text: cat.name,
          type: SuggestionType.category,
          count: cat.productCount,
        ),
      );
    }
  }

  for (final style in styles) {
    if (style.name.toLowerCase().contains(query) && seen.add(style.name)) {
      suggestions.add(
        SearchSuggestion(text: style.name, type: SuggestionType.style),
      );
    }
  }

  final materials = <String>{};
  for (final p in products) {
    for (final m in p.materials) {
      if (m.toLowerCase().contains(query) && materials.add(m.toLowerCase())) {
        suggestions.add(
          SearchSuggestion(text: m, type: SuggestionType.material),
        );
      }
    }
  }

  for (final p in products) {
    if (p.name.toLowerCase().contains(query) && seen.add(p.id)) {
      suggestions.add(
        SearchSuggestion(
          text: p.name,
          type: SuggestionType.product,
          productId: p.id,
        ),
      );
      if (suggestions.length >= 8) break;
    }
  }

  return suggestions.take(8).toList();
});

enum SuggestionType { category, style, material, product }

class SearchSuggestion {
  final String text;
  final SuggestionType type;
  final int? count;
  final String? productId;

  const SearchSuggestion({
    required this.text,
    required this.type,
    this.count,
    this.productId,
  });
}
