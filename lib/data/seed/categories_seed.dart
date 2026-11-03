import '../models/furniture.dart';

class SeedCategories {
  static const List<FurnitureCategory> all = [
    FurnitureCategory(
      id: 'sofas',
      name: 'Sofas',
      description: 'Comfortable seating for living spaces, from compact loveseats to expansive sectionals.',
      iconCodePoint: 0xe945, // Icons.weekend
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'beds',
      name: 'Beds',
      description: 'Platform beds, upholstered frames, and bedroom essentials for restful sleep.',
      iconCodePoint: 0xefeb, // Icons.bed
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'chairs',
      name: 'Chairs',
      description: 'Accent chairs, dining chairs, office seats, and lounge options for every room.',
      iconCodePoint: 0xefed, // Icons.chair
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'tables',
      name: 'Tables',
      description: 'Coffee tables, dining tables, side tables, and desks in a range of styles.',
      iconCodePoint: 0xf0a0, // Icons.table_restaurant
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'storage',
      name: 'Storage',
      description: 'Bookshelves, sideboards, dressers, and organizers to keep spaces tidy.',
      iconCodePoint: 0xe1bc, // Icons.inventory_2
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'lighting',
      name: 'Lighting',
      description: 'Floor lamps, pendant lights, table lamps, and sconces to set the mood.',
      iconCodePoint: 0xe518, // Icons.lightbulb
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'rugs',
      name: 'Rugs',
      description: 'Area rugs, runners, and accent pieces to ground your interior design.',
      iconCodePoint: 0xf547, // Icons.square_foot (approximate – rug-like)
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'decor',
      name: 'Decor',
      description: 'Vases, mirrors, wall art, cushions, and finishing touches that complete a room.',
      iconCodePoint: 0xea23, // Icons.palette
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'cabinets',
      name: 'Cabinets',
      description: 'Display cabinets, wardrobes, TV units, and built-in storage solutions.',
      iconCodePoint: 0xe30b, // Icons.kitchen
      productCount: 12,
    ),
    FurnitureCategory(
      id: 'outdoor',
      name: 'Outdoor',
      description: 'Patio sets, garden benches, outdoor dining, and weather-resistant furnishings.',
      iconCodePoint: 0xe52f, // Icons.deck
      productCount: 12,
    ),
  ];
}
