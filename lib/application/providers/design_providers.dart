import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:room_aura/data/models/room.dart';
import 'package:room_aura/data/repositories/design_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final designRepositoryProvider = Provider<DesignRepository>((ref) {
  return DesignRepository(ref.read(sharedPreferencesProvider));
});

final allDesignsProvider =
    StateNotifierProvider<DesignsNotifier, List<RoomDesign>>((ref) {
      final repo = ref.read(designRepositoryProvider);
      return DesignsNotifier(repo);
    });

class DesignsNotifier extends StateNotifier<List<RoomDesign>> {
  final DesignRepository _repo;

  DesignsNotifier(this._repo) : super(_repo.getAllDesigns());

  Future<void> save(RoomDesign design) async {
    await _repo.saveDesign(design);
    state = _repo.getAllDesigns();
  }

  Future<void> delete(String id) async {
    await _repo.deleteDesign(id);
    state = _repo.getAllDesigns();
  }

  Future<RoomDesign> duplicate(String id) async {
    final copy = await _repo.duplicateDesign(id);
    state = _repo.getAllDesigns();
    return copy;
  }

  Future<void> resetSeedDesigns() async {
    await _repo.resetSeedDesigns();
    state = _repo.getAllDesigns();
  }

  void refresh() {
    state = _repo.getAllDesigns();
  }
}

final currentDesignProvider = StateProvider<RoomDesign?>((ref) => null);

final selectedFurnitureProvider = StateProvider<String?>((ref) => null);
