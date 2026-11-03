import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:room_aura/data/models/cart.dart';
import 'package:room_aura/application/providers/design_providers.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return CartNotifier(prefs);
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, item) => sum + item.quantity);
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0.0, (sum, item) => sum + item.subtotal);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final SharedPreferences _prefs;
  static const _key = 'cart_items';

  CartNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List;
      state = list
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> _save() async {
    await _prefs.setString(
      _key,
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addItem(CartItem item) async {
    final idx = state.indexWhere((e) => e.productId == item.productId);
    if (idx >= 0) {
      final existing = state[idx];
      state = [
        ...state.sublist(0, idx),
        existing.copyWith(quantity: existing.quantity + item.quantity),
        ...state.sublist(idx + 1),
      ];
    } else {
      state = [...state, item];
    }
    await _save();
  }

  Future<void> removeItem(String productId) async {
    state = state.where((e) => e.productId != productId).toList();
    await _save();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }
    final idx = state.indexWhere((e) => e.productId == productId);
    if (idx < 0) return;
    state = [
      ...state.sublist(0, idx),
      state[idx].copyWith(quantity: quantity),
      ...state.sublist(idx + 1),
    ];
    await _save();
  }

  Future<void> clear() async {
    state = [];
    await _save();
  }
}
