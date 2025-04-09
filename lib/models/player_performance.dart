class PlayerPerformance2 {
  String id;
  String playerId;
  String matchId;
  double? topSpeed;
  double? avgSpeed;
  double? distanceKm;
  int? sprintCount;
  int? accelerations;
  int? passesCompleted;
  int? shotsOnTarget;
  int? interceptions;
  int? tackles;
  List<int>? embedding;
  int? heartRateAvg;
  int? heartRateMax;
  double? bodyTempC;
  double? fatigueScore;
  double? staminaScore;
  String? heatmapUrl;
  Map<String, dynamic>? positionLog;
  DateTime createdAt;

  PlayerPerformance2({
    required this.id,
    required this.playerId,
    required this.matchId,
    this.topSpeed,
    this.avgSpeed,
    this.distanceKm,
    this.sprintCount,
    this.accelerations,
    this.passesCompleted,
    this.shotsOnTarget,
    this.interceptions,
    this.tackles,
    this.embedding,
    this.heartRateAvg,
    this.heartRateMax,
    this.bodyTempC,
    this.fatigueScore,
    this.staminaScore,
    this.heatmapUrl,
    this.positionLog,
    required this.createdAt,
  });

  factory PlayerPerformance2.fromJson(Map<String, dynamic> json) =>
      PlayerPerformance2(
        id: json['id'],
        playerId: json['playerId'],
        matchId: json['matchId'],
        topSpeed: json['topSpeed']?.toDouble(),
        avgSpeed: json['avgSpeed']?.toDouble(),
        distanceKm: json['distanceKm']?.toDouble(),
        sprintCount: json['sprintCount'],
        accelerations: json['accelerations'],
        passesCompleted: json['passesCompleted'],
        shotsOnTarget: json['shotsOnTarget'],
        interceptions: json['interceptions'],
        tackles: json['tackles'],
        embedding:
            json['embedding'] != null
                ? List<int>.from(json['embedding'])
                : null,
        heartRateAvg: json['heartRateAvg'],
        heartRateMax: json['heartRateMax'],
        bodyTempC: json['bodyTempC']?.toDouble(),
        fatigueScore: json['fatigueScore']?.toDouble(),
        staminaScore: json['staminaScore']?.toDouble(),
        heatmapUrl: json['heatmapUrl'],
        positionLog: json['positionLog'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'matchId': matchId,
    'topSpeed': topSpeed,
    'avgSpeed': avgSpeed,
    'distanceKm': distanceKm,
    'sprintCount': sprintCount,
    'accelerations': accelerations,
    'passesCompleted': passesCompleted,
    'shotsOnTarget': shotsOnTarget,
    'interceptions': interceptions,
    'tackles': tackles,
    'embedding': embedding,
    'heartRateAvg': heartRateAvg,
    'heartRateMax': heartRateMax,
    'bodyTempC': bodyTempC,
    'fatigueScore': fatigueScore,
    'staminaScore': staminaScore,
    'heatmapUrl': heatmapUrl,
    'positionLog': positionLog,
    'createdAt': createdAt.toIso8601String(),
  };
}
