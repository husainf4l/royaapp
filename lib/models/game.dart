import 'replay_moment.dart';

class Game {
  String id;
  String homeTeam;
  String awayTeam;
  int homeScore;
  int awayScore;
  String currentTime;
  String matchPhase;
  List<ReplayMoment> moments;
  DateTime createdAt;
  DateTime updatedAt;

  Game({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.currentTime,
    required this.matchPhase,
    required this.moments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    id: json['id'],
    homeTeam: json['homeTeam'],
    awayTeam: json['awayTeam'],
    homeScore: json['homeScore'],
    awayScore: json['awayScore'],
    currentTime: json['currentTime'],
    matchPhase: json['matchPhase'],
    moments:
        (json['moments'] as List).map((e) => ReplayMoment.fromJson(e)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'homeTeam': homeTeam,
    'awayTeam': awayTeam,
    'homeScore': homeScore,
    'awayScore': awayScore,
    'currentTime': currentTime,
    'matchPhase': matchPhase,
    'moments': moments.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
