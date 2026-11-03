import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:room_aura/data/models/room.dart';

class DesignRepository {
  final SharedPreferences _prefs;
  static const _designsKey = 'saved_designs';
  static const _uuid = Uuid();

  DesignRepository(this._prefs);

  List<RoomDesign> getAllDesigns() {
    final raw = _prefs.getString(_designsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => RoomDesign.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return [];
    }
  }

  RoomDesign? getById(String id) {
    final designs = getAllDesigns();
    for (final d in designs) {
      if (d.id == id) return d;
    }
    return null;
  }

  Future<void> saveDesign(RoomDesign design) async {
    final designs = getAllDesigns();
    final index = designs.indexWhere((d) => d.id == design.id);
    if (index >= 0) {
      designs[index] = design;
    } else {
      designs.add(design);
    }
    await _persist(designs);
  }

  Future<void> deleteDesign(String id) async {
    final designs = getAllDesigns();
    designs.removeWhere((d) => d.id == id);
    await _persist(designs);
  }

  Future<RoomDesign> duplicateDesign(String id) async {
    final original = getById(id);
    if (original == null) {
      throw StateError('Design not found: $id');
    }
    final now = DateTime.now();
    final copy = RoomDesign(
      id: _uuid.v4(),
      name: 'Copy of ${original.name}',
      roomType: original.roomType,
      width: original.width,
      length: original.length,
      height: original.height,
      wallColor: original.wallColor,
      floorColor: original.floorColor,
      floorMaterial: original.floorMaterial,
      furniture: original.furniture
          .map(
            (f) => PlacedFurniture(
              id: _uuid.v4(),
              furnitureId: f.furnitureId,
              name: f.name,
              x: f.x,
              y: f.y,
              width: f.width,
              depth: f.depth,
              rotation: f.rotation,
              color: f.color,
              material: f.material,
            ),
          )
          .toList(),
      createdAt: now,
      updatedAt: now,
      isDraft: true,
    );
    await saveDesign(copy);
    return copy;
  }

  List<RoomDesign> getDrafts() {
    return getAllDesigns().where((d) => d.isDraft).toList();
  }

  Future<void> resetSeedDesigns() async {
    final designs = getAllDesigns();
    designs.removeWhere((d) => d.templateId != null);
    await _persist(designs);
  }

  Future<void> _persist(List<RoomDesign> designs) async {
    final encoded = jsonEncode(designs.map((d) => d.toJson()).toList());
    await _prefs.setString(_designsKey, encoded);
  }
}
