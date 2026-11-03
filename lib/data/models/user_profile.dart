class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final List<String> favoriteProductIds;
  final List<String> recentlyViewedIds;
  final String preferredStyle;
  final bool isDemoAccount;

  const UserProfile({
    required this.id,
    this.displayName = 'Demo User',
    this.email = 'demo@roomaura.local',
    this.favoriteProductIds = const [],
    this.recentlyViewedIds = const [],
    this.preferredStyle = '',
    this.isDemoAccount = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'favoriteProductIds': favoriteProductIds,
    'recentlyViewedIds': recentlyViewedIds,
    'preferredStyle': preferredStyle,
    'isDemoAccount': isDemoAccount,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    displayName: json['displayName'] as String? ?? 'Demo User',
    email: json['email'] as String? ?? 'demo@roomaura.local',
    favoriteProductIds:
        (json['favoriteProductIds'] as List?)?.cast<String>() ?? [],
    recentlyViewedIds:
        (json['recentlyViewedIds'] as List?)?.cast<String>() ?? [],
    preferredStyle: json['preferredStyle'] as String? ?? '',
    isDemoAccount: json['isDemoAccount'] as bool? ?? true,
  );

  UserProfile copyWith({
    String? displayName,
    String? email,
    List<String>? favoriteProductIds,
    List<String>? recentlyViewedIds,
    String? preferredStyle,
  }) => UserProfile(
    id: id,
    displayName: displayName ?? this.displayName,
    email: email ?? this.email,
    favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    recentlyViewedIds: recentlyViewedIds ?? this.recentlyViewedIds,
    preferredStyle: preferredStyle ?? this.preferredStyle,
    isDemoAccount: isDemoAccount,
  );
}
