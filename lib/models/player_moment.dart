import 'player.dart';
import 'replay_moment.dart';

class PlayerMoment {
  String playerId;
  Player player;
  String replayMomentId;
  ReplayMoment replayMoment;
  List<int>? embedding;

  PlayerMoment({
    required this.playerId,
    required this.player,
    required this.replayMomentId,
    required this.replayMoment,
    this.embedding,
  });

  factory PlayerMoment.fromJson(Map<String, dynamic> json) => PlayerMoment(
    playerId: json['playerId'],
    player: Player.fromJson(json['player']),
    replayMomentId: json['replayMomentId'],
    replayMoment: ReplayMoment.fromJson(json['replayMoment']),
    embedding:
        json['embedding'] != null ? List<int>.from(json['embedding']) : null,
  );

  Map<String, dynamic> toJson() => {
    'playerId': playerId,
    'player': player.toJson(),
    'replayMomentId': replayMomentId,
    'replayMoment': replayMoment.toJson(),
    'embedding': embedding,
  };
}
