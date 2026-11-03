class DesignCollection {
  final String id;
  final String name;
  final String description;
  final List<String> productIds;
  final String? styleId;
  final int coverColor;
  final bool isSeeded;

  const DesignCollection({
    required this.id,
    required this.name,
    required this.description,
    this.productIds = const [],
    this.styleId,
    required this.coverColor,
    this.isSeeded = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'productIds': productIds,
    'styleId': styleId,
    'coverColor': coverColor,
    'isSeeded': isSeeded,
  };

  factory DesignCollection.fromJson(Map<String, dynamic> json) =>
      DesignCollection(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        productIds: (json['productIds'] as List?)?.cast<String>() ?? [],
        styleId: json['styleId'] as String?,
        coverColor: json['coverColor'] as int,
        isSeeded: json['isSeeded'] as bool? ?? false,
      );

  DesignCollection copyWith({List<String>? productIds}) => DesignCollection(
    id: id,
    name: name,
    description: description,
    productIds: productIds ?? this.productIds,
    styleId: styleId,
    coverColor: coverColor,
    isSeeded: isSeeded,
  );
}
