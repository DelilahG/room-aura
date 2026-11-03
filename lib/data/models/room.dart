class RoomDesign {
  final String id;
  final String name;
  final String roomType;
  final double width;
  final double length;
  final double height;
  final int wallColor;
  final int floorColor;
  final String floorMaterial;
  final List<PlacedFurniture> furniture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDraft;
  final String? templateId;
  final String? thumbnailColor;

  const RoomDesign({
    required this.id,
    required this.name,
    required this.roomType,
    this.width = 4.0,
    this.length = 5.0,
    this.height = 2.8,
    this.wallColor = 0xFFF5F0EB,
    this.floorColor = 0xFFD4C5B2,
    this.floorMaterial = 'Hardwood',
    this.furniture = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isDraft = true,
    this.templateId,
    this.thumbnailColor,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'roomType': roomType,
    'width': width,
    'length': length,
    'height': height,
    'wallColor': wallColor,
    'floorColor': floorColor,
    'floorMaterial': floorMaterial,
    'furniture': furniture.map((f) => f.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isDraft': isDraft,
    'templateId': templateId,
    'thumbnailColor': thumbnailColor,
  };

  factory RoomDesign.fromJson(Map<String, dynamic> json) => RoomDesign(
    id: json['id'] as String,
    name: json['name'] as String,
    roomType: json['roomType'] as String,
    width: (json['width'] as num).toDouble(),
    length: (json['length'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    wallColor: json['wallColor'] as int,
    floorColor: json['floorColor'] as int,
    floorMaterial: json['floorMaterial'] as String? ?? 'Hardwood',
    furniture:
        (json['furniture'] as List?)
            ?.map((f) => PlacedFurniture.fromJson(f as Map<String, dynamic>))
            .toList() ??
        [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    isDraft: json['isDraft'] as bool? ?? true,
    templateId: json['templateId'] as String?,
    thumbnailColor: json['thumbnailColor'] as String?,
  );

  RoomDesign copyWith({
    String? name,
    String? roomType,
    double? width,
    double? length,
    double? height,
    int? wallColor,
    int? floorColor,
    String? floorMaterial,
    List<PlacedFurniture>? furniture,
    DateTime? updatedAt,
    bool? isDraft,
  }) => RoomDesign(
    id: id,
    name: name ?? this.name,
    roomType: roomType ?? this.roomType,
    width: width ?? this.width,
    length: length ?? this.length,
    height: height ?? this.height,
    wallColor: wallColor ?? this.wallColor,
    floorColor: floorColor ?? this.floorColor,
    floorMaterial: floorMaterial ?? this.floorMaterial,
    furniture: furniture ?? this.furniture,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDraft: isDraft ?? this.isDraft,
    templateId: templateId,
    thumbnailColor: thumbnailColor,
  );
}

class PlacedFurniture {
  final String id;
  final String furnitureId;
  final String name;
  final double x;
  final double y;
  final double width;
  final double depth;
  final double rotation;
  final int color;
  final String? material;

  const PlacedFurniture({
    required this.id,
    required this.furnitureId,
    required this.name,
    required this.x,
    required this.y,
    required this.width,
    required this.depth,
    this.rotation = 0,
    this.color = 0xFF8B7355,
    this.material,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'furnitureId': furnitureId,
    'name': name,
    'x': x,
    'y': y,
    'width': width,
    'depth': depth,
    'rotation': rotation,
    'color': color,
    'material': material,
  };

  factory PlacedFurniture.fromJson(Map<String, dynamic> json) =>
      PlacedFurniture(
        id: json['id'] as String,
        furnitureId: json['furnitureId'] as String,
        name: json['name'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
        rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
        color: json['color'] as int? ?? 0xFF8B7355,
        material: json['material'] as String?,
      );

  PlacedFurniture copyWith({
    double? x,
    double? y,
    double? rotation,
    double? width,
    double? depth,
    int? color,
    String? material,
  }) => PlacedFurniture(
    id: id,
    furnitureId: furnitureId,
    name: name,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    depth: depth ?? this.depth,
    rotation: rotation ?? this.rotation,
    color: color ?? this.color,
    material: material ?? this.material,
  );
}

class RoomTemplate {
  final String id;
  final String name;
  final String roomType;
  final String description;
  final double width;
  final double length;
  final double height;
  final int wallColor;
  final int floorColor;
  final String floorMaterial;
  final String style;
  final List<PlacedFurniture> suggestedFurniture;

  const RoomTemplate({
    required this.id,
    required this.name,
    required this.roomType,
    required this.description,
    required this.width,
    required this.length,
    this.height = 2.8,
    this.wallColor = 0xFFF5F0EB,
    this.floorColor = 0xFFD4C5B2,
    this.floorMaterial = 'Hardwood',
    required this.style,
    this.suggestedFurniture = const [],
  });
}
