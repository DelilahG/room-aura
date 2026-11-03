import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:room_aura/data/models/user_profile.dart';
import 'package:room_aura/core/constants/app_constants.dart';

class UserRepository {
  final SharedPreferences _prefs;
  static const _profileKey = 'user_profile';
  static const _defaultId = 'demo-user-001';

  UserRepository(this._prefs);

  UserProfile getProfile() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) return _defaultProfile();
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return _defaultProfile();
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<void> toggleFavorite(String productId) async {
    final profile = getProfile();
    final favorites = List<String>.from(profile.favoriteProductIds);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    await updateProfile(profile.copyWith(favoriteProductIds: favorites));
  }

  bool isFavorite(String productId) {
    return getProfile().favoriteProductIds.contains(productId);
  }

  List<String> getFavorites() {
    return getProfile().favoriteProductIds;
  }

  Future<void> addRecentlyViewed(String productId) async {
    final profile = getProfile();
    final recent = List<String>.from(profile.recentlyViewedIds);
    recent.remove(productId);
    recent.insert(0, productId);
    if (recent.length > AppConstants.recentlyViewedLimit) {
      recent.removeRange(AppConstants.recentlyViewedLimit, recent.length);
    }
    await updateProfile(profile.copyWith(recentlyViewedIds: recent));
  }

  List<String> getRecentlyViewed() {
    return getProfile().recentlyViewedIds;
  }

  Future<void> resetDemoData() async {
    await updateProfile(_defaultProfile());
  }

  UserProfile _defaultProfile() => const UserProfile(
    id: _defaultId,
    displayName: 'Demo User',
    email: 'demo@roomaura.local',
    isDemoAccount: true,
  );
}
