import 'package:flutter_test/flutter_test.dart';
import 'package:room_aura/data/models/furniture.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/data/models/user_profile.dart';
import 'package:room_aura/data/seed/furniture_seed.dart';
import 'package:room_aura/data/seed/styles_seed.dart';
import 'package:room_aura/data/seed/rooms_seed.dart';
import 'package:room_aura/data/seed/templates_seed.dart';
import 'package:room_aura/data/seed/collections_seed.dart';
import 'package:room_aura/data/seed/reviews_seed.dart';
import 'package:room_aura/data/seed/categories_seed.dart';
import 'package:room_aura/data/seed/materials_seed.dart';
import 'package:room_aura/data/repositories/furniture_repository.dart';

void main() {
  group('Seed Data Integrity', () {
    test('should have exactly 120 furniture products', () {
      expect(SeedFurniture.all.length, 120);
    });

    test('should have 12 products per category', () {
      final categories = [
        'Sofas',
        'Beds',
        'Chairs',
        'Tables',
        'Storage',
        'Lighting',
        'Rugs',
        'Decor',
        'Cabinets',
        'Outdoor',
      ];
      for (final cat in categories) {
        final count = SeedFurniture.all.where((p) => p.category == cat).length;
        expect(count, 12, reason: 'Expected 12 $cat products, found $count');
      }
    });

    test('all product IDs should be unique', () {
      final ids = SeedFurniture.all.map((p) => p.id).toSet();
      expect(ids.length, SeedFurniture.all.length);
    });

    test('should have 12 interior styles', () {
      expect(SeedStyles.all.length, 12);
    });

    test('should have 30 inspiration rooms', () {
      expect(SeedRooms.all.length, 30);
    });

    test('should have 15 room templates', () {
      expect(SeedTemplates.all.length, 15);
    });

    test('should have 10 collections', () {
      expect(SeedCollections.all.length, 10);
    });

    test('should have 80 reviews', () {
      expect(SeedReviews.all.length, 80);
    });

    test('should have 10 categories', () {
      expect(SeedCategories.all.length, 10);
    });

    test('should have 50 materials', () {
      expect(SeedMaterials.all.length, 50);
    });

    test('all products should have positive prices', () {
      for (final p in SeedFurniture.all) {
        expect(p.price, greaterThan(0), reason: '${p.name} has invalid price');
      }
    });

    test('all products should have valid ratings', () {
      for (final p in SeedFurniture.all) {
        expect(p.rating, greaterThanOrEqualTo(0));
        expect(p.rating, lessThanOrEqualTo(5));
      }
    });
  });

  group('FurnitureProduct Model', () {
    late FurnitureProduct product;

    setUp(() {
      product = SeedFurniture.all.first;
    });

    test('toJson/fromJson round-trip', () {
      final json = product.toJson();
      final restored = FurnitureProduct.fromJson(json);
      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.category, product.category);
      expect(restored.price, product.price);
      expect(restored.rating, product.rating);
    });

    test('dimensions serialization', () {
      final dims = product.dimensions;
      final json = dims.toJson();
      final restored = FurnitureDimensions.fromJson(json);
      expect(restored.width, dims.width);
      expect(restored.depth, dims.depth);
      expect(restored.height, dims.height);
    });
  });

  group('RoomDesign Model', () {
    test('creates with defaults', () {
      final room = RoomDesign(
        id: 'test-1',
        name: 'Test Room',
        roomType: 'Living Room',
        width: 5.0,
        length: 4.0,
        height: 2.8,
        wallColor: 0xFFF5F0EB,
        floorColor: 0xFFD4C5B2,
        floorMaterial: 'Hardwood',
        furniture: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDraft: true,
      );
      expect(room.furniture, isEmpty);
      expect(room.isDraft, isTrue);
    });

    test('toJson/fromJson round-trip', () {
      final now = DateTime.now();
      final room = RoomDesign(
        id: 'test-2',
        name: 'Kitchen',
        roomType: 'Kitchen',
        width: 3.5,
        length: 4.0,
        height: 2.5,
        wallColor: 0xFFFFFFFF,
        floorColor: 0xFF888888,
        floorMaterial: 'Tile',
        furniture: [
          PlacedFurniture(
            id: 'pf-1',
            furnitureId: 'table_001',
            name: 'Test Table',
            x: 1.0,
            y: 2.0,
            width: 1.2,
            depth: 0.8,
            rotation: 45,
            color: 0xFF8B7355,
            material: 'Oak',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        isDraft: false,
      );

      final json = room.toJson();
      final restored = RoomDesign.fromJson(json);
      expect(restored.id, 'test-2');
      expect(restored.name, 'Kitchen');
      expect(restored.width, 3.5);
      expect(restored.furniture.length, 1);
      expect(restored.furniture.first.name, 'Test Table');
      expect(restored.furniture.first.rotation, 45);
    });

    test('copyWith preserves unchanged values', () {
      final room = RoomDesign(
        id: 'test-3',
        name: 'Bedroom',
        roomType: 'Bedroom',
        width: 4.0,
        length: 5.0,
        height: 2.8,
        wallColor: 0xFFFFFFFF,
        floorColor: 0xFF999999,
        floorMaterial: 'Carpet',
        furniture: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDraft: true,
      );

      final updated = room.copyWith(name: 'Master Bedroom', isDraft: false);
      expect(updated.name, 'Master Bedroom');
      expect(updated.isDraft, false);
      expect(updated.id, room.id);
      expect(updated.width, room.width);
      expect(updated.roomType, room.roomType);
    });
  });

  group('UserProfile Model', () {
    test('toJson/fromJson round-trip', () {
      final profile = UserProfile(
        id: 'test-user-1',
        displayName: 'Test User',
        email: 'test@example.com',
        preferredStyle: 'scandinavian',
        favoriteProductIds: ['sofa_001', 'table_002'],
        recentlyViewedIds: ['chair_003'],
        isDemoAccount: true,
      );

      final json = profile.toJson();
      final restored = UserProfile.fromJson(json);
      expect(restored.displayName, 'Test User');
      expect(restored.favoriteProductIds.length, 2);
      expect(restored.isDemoAccount, isTrue);
    });

    test('copyWith for favorite toggle', () {
      final profile = UserProfile(
        id: 'test-user-2',
        displayName: 'User',
        email: '',
        preferredStyle: '',
        favoriteProductIds: ['a', 'b'],
        recentlyViewedIds: [],
        isDemoAccount: false,
      );

      final toggled = profile.copyWith(
        favoriteProductIds: [...profile.favoriteProductIds, 'c'],
      );
      expect(toggled.favoriteProductIds, contains('c'));
      expect(toggled.favoriteProductIds.length, 3);
    });
  });

  group('FurnitureRepository', () {
    late FurnitureRepository repo;

    setUp(() {
      repo = FurnitureRepository();
    });

    test('getAllProducts returns 120 items', () {
      expect(repo.getAllProducts().length, 120);
    });

    test('getById returns correct product', () {
      final product = repo.getById('sofa_001');
      expect(product, isNotNull);
      expect(product!.name, contains('Sofa'));
    });

    test('getById returns null for invalid ID', () {
      expect(repo.getById('nonexistent'), isNull);
    });

    test('getByCategory filters correctly', () {
      final sofas = repo.getByCategory('Sofas');
      expect(sofas.length, 12);
      expect(sofas.every((p) => p.category == 'Sofas'), isTrue);
    });

    test('search finds products by name', () {
      final results = repo.search('sofa');
      expect(results, isNotEmpty);
    });

    test('getFeatured returns featured products', () {
      final featured = repo.getFeatured();
      expect(featured, isNotEmpty);
      expect(featured.every((p) => p.isFeatured), isTrue);
    });

    test('getNew returns new products', () {
      final newProducts = repo.getNew();
      expect(newProducts, isNotEmpty);
      expect(newProducts.every((p) => p.isNew), isTrue);
    });

    test('getRelated returns related products excluding self', () {
      final related = repo.getRelated('sofa_001');
      expect(related, isNotEmpty);
      expect(related.every((p) => p.id != 'sofa_001'), isTrue);
    });

    test('filter by price range', () {
      final results = repo.filter(minPrice: 10000, maxPrice: 30000);
      expect(results, isNotEmpty);
      for (final p in results) {
        expect(p.price, greaterThanOrEqualTo(10000));
        expect(p.price, lessThanOrEqualTo(30000));
      }
    });

    test('getCategories returns all categories', () {
      final cats = repo.getCategories();
      expect(cats.length, 10);
    });

    test('getStyles returns all styles', () {
      final styles = repo.getStyles();
      expect(styles.length, 12);
    });

    test('getInspirationRooms returns 30 rooms', () {
      expect(repo.getInspirationRooms().length, 30);
    });

    test('getTemplates returns 15 templates', () {
      expect(repo.getTemplates().length, 15);
    });

    test('getCollections returns 10 collections', () {
      expect(repo.getCollections().length, 10);
    });
  });
}
