import 'player_moment.dart';
import 'game.dart';

class ReplayMoment {
  String id;
  String title;
  String description;
  String timestamp;
  int positionMinutes;
  int positionSeconds;
  String type;
  String? thumbnailUrl;
  int minute;
  List<PlayerMoment> players;
  String? gameId;
  Game? game;
  DateTime createdAt;
  DateTime updatedAt;

  ReplayMoment({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.positionMinutes,
    required this.positionSeconds,
    required this.type,
    this.thumbnailUrl,
    required this.minute,
    required this.players,
    this.gameId,
    this.game,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReplayMoment.fromJson(Map<String, dynamic> json) => ReplayMoment(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    timestamp: json['timestamp'],
    positionMinutes: json['positionMinutes'],
    positionSeconds: json['positionSeconds'],
    type: json['type'],
    thumbnailUrl: json['thumbnailUrl'],
    minute: json['minute'],
    players:
        (json['players'] as List).map((e) => PlayerMoment.fromJson(e)).toList(),
    gameId: json['gameId'],
    game: json['game'] != null ? Game.fromJson(json['game']) : null,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'timestamp': timestamp,
    'positionMinutes': positionMinutes,
    'positionSeconds': positionSeconds,
    'type': type,
    'thumbnailUrl': thumbnailUrl,
    'minute': minute,
    'players': players.map((e) => e.toJson()).toList(),
    'gameId': gameId,
    'game': game?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
