class LivePlayer {
  String id;
  String playerId;
  String? imageUrl;
  String? videoUrl;
  bool isActive;
  DateTime lastSeen;
  Map<String, dynamic>? coordinates;
  DateTime createdAt;
  DateTime updatedAt;
  List<int>? embedding;

  LivePlayer({
    required this.id,
    required this.playerId,
    this.imageUrl,
    this.videoUrl,
    required this.isActive,
    required this.lastSeen,
    this.coordinates,
    required this.createdAt,
    required this.updatedAt,
    this.embedding,
  });

  factory LivePlayer.fromJson(Map<String, dynamic> json) => LivePlayer(
    id: json['id'],
    playerId: json['playerId'],
    imageUrl: json['imageUrl'],
    videoUrl: json['videoUrl'],
    isActive: json['isActive'],
    lastSeen: DateTime.parse(json['lastSeen']),
    coordinates: json['coordinates'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    embedding:
        json['embedding'] != null ? List<int>.from(json['embedding']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'isActive': isActive,
    'lastSeen': lastSeen.toIso8601String(),
    'coordinates': coordinates,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'embedding': embedding,
  };
}
