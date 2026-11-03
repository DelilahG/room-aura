class InteriorStyle {
  final String id;
  final String name;
  final String description;
  final List<String> characteristics;
  final List<int> colorPalette;
  final List<String> keyMaterials;
  final String moodDescription;
  final int accentColor;

  const InteriorStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.characteristics,
    required this.colorPalette,
    required this.keyMaterials,
    required this.moodDescription,
    required this.accentColor,
  });
}

class InspirationRoom {
  final String id;
  final String title;
  final String description;
  final String styleId;
  final String roomType;
  final List<String> tags;
  final int primaryColor;
  final int secondaryColor;
  final String designer;
  final int likes;

  const InspirationRoom({
    required this.id,
    required this.title,
    required this.description,
    required this.styleId,
    required this.roomType,
    required this.tags,
    required this.primaryColor,
    required this.secondaryColor,
    this.designer = '',
    this.likes = 0,
  });
}
