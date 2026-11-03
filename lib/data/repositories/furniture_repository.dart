import 'package:room_aura/data/models/furniture.dart';
import 'package:room_aura/data/models/style.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/data/models/collection.dart';
import 'package:room_aura/data/models/review.dart';
import 'package:room_aura/data/seed/furniture_seed.dart';
import 'package:room_aura/data/seed/styles_seed.dart';
import 'package:room_aura/data/seed/rooms_seed.dart';
import 'package:room_aura/data/seed/templates_seed.dart';
import 'package:room_aura/data/seed/collections_seed.dart';
import 'package:room_aura/data/seed/reviews_seed.dart';
import 'package:room_aura/data/seed/categories_seed.dart';

class FurnitureRepository {
  List<FurnitureProduct> getAllProducts() => SeedFurniture.all;

  FurnitureProduct? getById(String id) {
    final products = SeedFurniture.all;
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<FurnitureProduct> getByCategory(String category) {
    return SeedFurniture.all
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<FurnitureProduct> getByStyle(String styleId) {
    return SeedFurniture.all
        .where(
          (p) => p.styleTags.any(
            (tag) => tag.toLowerCase() == styleId.toLowerCase(),
          ),
        )
        .toList();
  }

  List<FurnitureProduct> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];
    return SeedFurniture.all.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.materials.any((m) => m.toLowerCase().contains(q)) ||
          p.styleTags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  List<FurnitureProduct> filter({
    String? category,
    String? style,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) {
    var results = SeedFurniture.all.toList();

    if (category != null && category.isNotEmpty) {
      results = results
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (style != null && style.isNotEmpty) {
      results = results
          .where(
            (p) =>
                p.styleTags.any((t) => t.toLowerCase() == style.toLowerCase()),
          )
          .toList();
    }

    if (minPrice != null) {
      results = results.where((p) => p.price >= minPrice).toList();
    }

    if (maxPrice != null) {
      results = results.where((p) => p.price <= maxPrice).toList();
    }

    switch (sortBy) {
      case 'price_asc':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        results.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
        break;
      case 'name':
      default:
        results.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return results;
  }

  List<FurnitureProduct> getFeatured() {
    return SeedFurniture.all.where((p) => p.isFeatured).toList();
  }

  List<FurnitureProduct> getNew() {
    return SeedFurniture.all.where((p) => p.isNew).toList();
  }

  List<FurnitureProduct> getRelated(String productId, {int limit = 8}) {
    final product = getById(productId);
    if (product == null) return [];

    final scored = <(FurnitureProduct, int)>[];
    for (final p in SeedFurniture.all) {
      if (p.id == productId) continue;
      int score = 0;
      if (p.category == product.category) score += 3;
      for (final tag in p.styleTags) {
        if (product.styleTags.contains(tag)) score += 1;
      }
      if (score > 0) scored.add((p, score));
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.take(limit).map((e) => e.$1).toList();
  }

  List<FurnitureCategory> getCategories() => SeedCategories.all;

  List<InteriorStyle> getStyles() => SeedStyles.all;

  List<InspirationRoom> getInspirationRooms() => SeedRooms.all;

  List<RoomTemplate> getTemplates() => SeedTemplates.all;

  List<ProductReview> getReviewsForProduct(String productId) {
    return SeedReviews.all.where((r) => r.productId == productId).toList();
  }

  List<DesignCollection> getCollections() => SeedCollections.all;
}
