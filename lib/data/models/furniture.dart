class FurnitureProduct {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final String description;
  final double price;
  final FurnitureDimensions dimensions;
  final List<String> materials;
  final List<FurnitureColor> availableColors;
  final List<String> styleTags;
  final List<String> imageUrls;
  final String? modelPath;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;

  const FurnitureProduct({
    required this.id,
    required this.name,
    required this.category,
    this.subcategory = '',
    required this.description,
    required this.price,
    required this.dimensions,
    required this.materials,
    required this.availableColors,
    required this.styleTags,
    required this.imageUrls,
    this.modelPath,
    this.rating = 0,
    this.reviewCount = 0,
    this.isNew = false,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'subcategory': subcategory,
    'description': description,
    'price': price,
    'dimensions': dimensions.toJson(),
    'materials': materials,
    'availableColors': availableColors.map((c) => c.toJson()).toList(),
    'styleTags': styleTags,
    'imageUrls': imageUrls,
    'modelPath': modelPath,
    'rating': rating,
    'reviewCount': reviewCount,
    'isNew': isNew,
    'isFeatured': isFeatured,
  };

  factory FurnitureProduct.fromJson(Map<String, dynamic> json) =>
      FurnitureProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        subcategory: json['subcategory'] as String? ?? '',
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        dimensions: FurnitureDimensions.fromJson(
          json['dimensions'] as Map<String, dynamic>,
        ),
        materials: (json['materials'] as List).cast<String>(),
        availableColors: (json['availableColors'] as List)
            .map((c) => FurnitureColor.fromJson(c as Map<String, dynamic>))
            .toList(),
        styleTags: (json['styleTags'] as List).cast<String>(),
        imageUrls: (json['imageUrls'] as List).cast<String>(),
        modelPath: json['modelPath'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        isNew: json['isNew'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
      );

  FurnitureProduct copyWith({bool? isFeatured}) => FurnitureProduct(
    id: id,
    name: name,
    category: category,
    subcategory: subcategory,
    description: description,
    price: price,
    dimensions: dimensions,
    materials: materials,
    availableColors: availableColors,
    styleTags: styleTags,
    imageUrls: imageUrls,
    modelPath: modelPath,
    rating: rating,
    reviewCount: reviewCount,
    isNew: isNew,
    isFeatured: isFeatured ?? this.isFeatured,
  );
}

class FurnitureDimensions {
  final double width;
  final double depth;
  final double height;

  const FurnitureDimensions({
    required this.width,
    required this.depth,
    required this.height,
  });

  String get formatted =>
      '${width.toStringAsFixed(0)} × ${depth.toStringAsFixed(0)} × ${height.toStringAsFixed(0)} cm';

  Map<String, dynamic> toJson() => {
    'width': width,
    'depth': depth,
    'height': height,
  };

  factory FurnitureDimensions.fromJson(Map<String, dynamic> json) =>
      FurnitureDimensions(
        width: (json['width'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
      );
}

class FurnitureColor {
  final String name;
  final int colorValue;

  const FurnitureColor({required this.name, required this.colorValue});

  Map<String, dynamic> toJson() => {'name': name, 'colorValue': colorValue};

  factory FurnitureColor.fromJson(Map<String, dynamic> json) => FurnitureColor(
    name: json['name'] as String,
    colorValue: json['colorValue'] as int,
  );
}

class FurnitureCategory {
  final String id;
  final String name;
  final String description;
  final int iconCodePoint;
  final int productCount;

  const FurnitureCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCodePoint,
    this.productCount = 0,
  });
}
