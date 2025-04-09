import 'package:royaapp/models/player_analysis.dart';

import 'player_performance.dart';
import 'live_player.dart';
import 'player_moment.dart';

class Player {
  String id;
  String name;
  int number;
  String position;
  String team;
  String nationality;
  List<PlayerAnalysis> performances;
  LivePlayer? livePlayer;
  List<PlayerMoment> playerMoments;
  String? imageUrl;
  DateTime createdAt;
  DateTime updatedAt;
  List<int>? embedding;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.team,
    required this.nationality,
    required this.performances,
    this.livePlayer,
    required this.playerMoments,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.embedding,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    number: json['number'] ?? 0,
    position: json['position'] ?? '',
    team: json['team'] ?? '',
    nationality: json['nationality'] ?? '',
    performances:
        json['performances'] != null
            ? (json['performances'] as List)
                .map((e) => PlayerAnalysis.fromJson(e))
                .toList()
            : [],
    livePlayer:
        json['livePlayer'] != null
            ? LivePlayer.fromJson(json['livePlayer'])
            : null,
    playerMoments:
        json['playerMoments'] != null
            ? (json['playerMoments'] as List)
                .map((e) => PlayerMoment.fromJson(e))
                .toList()
            : [],
    imageUrl: json['imageUrl'],
    createdAt:
        json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
    updatedAt:
        json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
    embedding:
        json['embedding'] != null ? List<int>.from(json['embedding']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'position': position,
    'team': team,
    'nationality': nationality,
    'livePlayer': livePlayer?.toJson(),
    'playerMoments': playerMoments.map((e) => e.toJson()).toList(),
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'embedding': embedding,
  };
}
