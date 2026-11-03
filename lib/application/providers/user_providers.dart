import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_aura/data/models/furniture.dart';
import 'package:room_aura/data/models/user_profile.dart';
import 'package:room_aura/data/repositories/user_repository.dart';
import 'package:room_aura/application/providers/design_providers.dart';
import 'package:room_aura/application/providers/furniture_providers.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.read(sharedPreferencesProvider));
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
      final repo = ref.read(userRepositoryProvider);
      return UserProfileNotifier(repo);
    });

class UserProfileNotifier extends StateNotifier<UserProfile> {
  final UserRepository _repo;

  UserProfileNotifier(this._repo) : super(_repo.getProfile());

  Future<void> updateDisplayName(String name) async {
    state = state.copyWith(displayName: name);
    await _repo.updateProfile(state);
  }

  Future<void> updateEmail(String email) async {
    state = state.copyWith(email: email);
    await _repo.updateProfile(state);
  }

  Future<void> updatePreferredStyle(String style) async {
    state = state.copyWith(preferredStyle: style);
    await _repo.updateProfile(state);
  }

  Future<void> toggleFavorite(String productId) async {
    await _repo.toggleFavorite(productId);
    state = _repo.getProfile();
  }

  Future<void> addRecentlyViewed(String productId) async {
    await _repo.addRecentlyViewed(productId);
    state = _repo.getProfile();
  }

  Future<void> resetDemoData() async {
    await _repo.resetDemoData();
    state = _repo.getProfile();
  }
}

final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  final profile = ref.watch(userProfileProvider);
  return profile.favoriteProductIds.contains(productId);
});

final recentlyViewedProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final repo = ref.read(furnitureRepositoryProvider);
  final products = <FurnitureProduct>[];
  for (final id in profile.recentlyViewedIds) {
    final p = repo.getById(id);
    if (p != null) products.add(p);
  }
  return products;
});

final favoriteProductsProvider = Provider<List<FurnitureProduct>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final repo = ref.read(furnitureRepositoryProvider);
  final products = <FurnitureProduct>[];
  for (final id in profile.favoriteProductIds) {
    final p = repo.getById(id);
    if (p != null) products.add(p);
  }
  return products;
});
