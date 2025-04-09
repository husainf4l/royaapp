// class PlayerAnalysis {
//   final String playerName;
//   final String physicalCondition;
//   final String tacticalRole;
//   final List<String>? videoReplayLinks;
//   final String? playerImageUrl;
//   final PlayerStatistics? statistics;
//   final List<MatchPerformance>? recentMatches;
//   final String? teamName;
//   final String? nationality;
//   final int? jerseyNumber;
//   final Map<String, double>? heatmapData;
//   final List<int>? embedding; // Added to align with schema

//   PlayerAnalysis({
//     required this.playerName,
//     required this.physicalCondition,
//     required this.tacticalRole,
//     this.videoReplayLinks,
//     this.playerImageUrl,
//     this.statistics,
//     this.recentMatches,
//     this.teamName,
//     this.nationality,
//     this.jerseyNumber,
//     this.heatmapData,
//     this.embedding, // Added to constructor
//   });

//   factory PlayerAnalysis.fromJson(Map<String, dynamic> json) {
//     return PlayerAnalysis(
//       playerName: json['playerName'] ?? 'Unknown Player',
//       physicalCondition: json['physicalCondition'] ?? 'Unknown',
//       tacticalRole: json['tacticalRole'] ?? 'Unknown',
//       videoReplayLinks:
//           json['videoReplayLinks'] != null
//               ? List<String>.from(json['videoReplayLinks'])
//               : null,
//       playerImageUrl: json['playerImageUrl'],
//       statistics:
//           json['statistics'] != null
//               ? PlayerStatistics.fromJson(json['statistics'])
//               : null,
//       recentMatches:
//           json['recentMatches'] != null
//               ? (json['recentMatches'] as List)
//                   .map((m) => MatchPerformance.fromJson(m))
//                   .toList()
//               : null,
//       teamName: json['teamName'],
//       nationality: json['nationality'],
//       jerseyNumber: json['jerseyNumber'],
//       heatmapData:
//           json['heatmapData'] != null
//               ? Map<String, double>.from(json['heatmapData'])
//               : null,
//       embedding:
//           json['embedding'] != null
//               ? List<int>.from(json['embedding'])
//               : null, // Added embedding parsing
//     );
//   }

//   // Enhanced mock data generator with variety
//   static PlayerAnalysis mockData() {
//     // Create a list of sample players for more variety
//     final players = [
//       {
//         'name': 'Lionel Messi',
//         'condition': 'Excellent',
//         'role': 'Forward / Right Winger',
//         'videos': [
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
//         ],
//         'image':
//             'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTuqmrx5e_mLUJdFRMBSjfvojvWtGs8th027w_2GVvqouy6dkr_MbHORDgV0GTq-PlKuqfFlhjJi1iIziGq9Rc2ag',
//         'team': 'Inter Miami CF',
//         'nationality': 'Argentina',
//         'number': 10,
//         'stats': PlayerStatistics(
//           goals: 842,
//           assists: 359,
//           matchesPlayed: 1047,
//           yellowCards: 78,
//           redCards: 3,
//           passAccuracy: 83.5,
//           shotsOnTarget: 76.2,
//           minutesPlayed: 88790,
//         ),
//         'matches': [
//           MatchPerformance(
//             opponent: 'Nashville SC',
//             date: '2023-08-19',
//             goals: 2,
//             assists: 1,
//             rating: 9.3,
//             minutesPlayed: 90,
//           ),
//           MatchPerformance(
//             opponent: 'Cincinnati',
//             date: '2023-08-26',
//             goals: 0,
//             assists: 2,
//             rating: 8.1,
//             minutesPlayed: 87,
//           ),
//           MatchPerformance(
//             opponent: 'Los Angeles FC',
//             date: '2023-09-03',
//             goals: 1,
//             assists: 0,
//             rating: 7.8,
//             minutesPlayed: 90,
//           ),
//         ],
//         'heatmap': {
//           'rightWing': 0.7,
//           'centerAttack': 0.5,
//           'leftWing': 0.1,
//           'midfield': 0.4,
//           'defense': 0.1,
//         },
//       },
//       {
//         'name': 'Cristiano Ronaldo',
//         'condition': 'Good',
//         'role': 'Center Forward',
//         'videos': [
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
//         ],
//         'image':
//             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFc0Cry8E_MF-5Qkl5umnXnZ77LI0B8tYKTn-nIG48KTFKnzxLHhIP2Usqb8Hsq0ERpH8_pM0M06a1kB-A0CToMw',
//         'team': 'Al Nassr',
//         'nationality': 'Portugal',
//         'number': 7,
//         'stats': PlayerStatistics(
//           goals: 875,
//           assists: 265,
//           matchesPlayed: 1168,
//           yellowCards: 136,
//           redCards: 11,
//           passAccuracy: 77.8,
//           shotsOnTarget: 82.1,
//           minutesPlayed: 98120,
//         ),
//         'matches': [
//           MatchPerformance(
//             opponent: 'Al-Hilal',
//             date: '2023-08-14',
//             goals: 1,
//             assists: 0,
//             rating: 8.2,
//             minutesPlayed: 90,
//           ),
//           MatchPerformance(
//             opponent: 'Al-Ittihad',
//             date: '2023-08-20',
//             goals: 2,
//             assists: 0,
//             rating: 8.7,
//             minutesPlayed: 90,
//           ),
//           MatchPerformance(
//             opponent: 'Al-Ahli',
//             date: '2023-08-27',
//             goals: 0,
//             assists: 1,
//             rating: 7.5,
//             minutesPlayed: 90,
//           ),
//         ],
//         'heatmap': {
//           'rightWing': 0.2,
//           'centerAttack': 0.8,
//           'leftWing': 0.2,
//           'midfield': 0.2,
//           'defense': 0.0,
//         },
//       },
//     ];

//     // Select a random player from the list
//     final randomIndex = DateTime.now().second % players.length;
//     final player = players[randomIndex];

//     return PlayerAnalysis(
//       playerName: player['name'] as String,
//       physicalCondition: player['condition'] as String,
//       tacticalRole: player['role'] as String,
//       videoReplayLinks: player['videos'] as List<String>,
//       playerImageUrl: player['image'] as String?,
//       teamName: player['team'] as String?,
//       nationality: player['nationality'] as String?,
//       jerseyNumber: player['number'] as int?,
//       statistics: player['stats'] as PlayerStatistics?,
//       recentMatches: player['matches'] as List<MatchPerformance>?,
//       heatmapData: player['heatmap'] as Map<String, double>?,
//       embedding: null, // Added embedding field
//     );
//   }
// }

// class PlayerStatistics {
//   final int goals;
//   final int assists;
//   final int matchesPlayed;
//   final int yellowCards;
//   final int redCards;
//   final double passAccuracy;
//   final double shotsOnTarget;
//   final int minutesPlayed;
//   final double? fatigueScore; // Added to align with schema
//   final double? staminaScore; // Added to align with schema

//   PlayerStatistics({
//     this.goals = 0,
//     this.assists = 0,
//     this.matchesPlayed = 0,
//     this.yellowCards = 0,
//     this.redCards = 0,
//     this.passAccuracy = 0.0,
//     this.shotsOnTarget = 0.0,
//     this.minutesPlayed = 0,
//     this.fatigueScore, // Added to constructor
//     this.staminaScore, // Added to constructor
//   });

//   factory PlayerStatistics.fromJson(Map<String, dynamic> json) {
//     return PlayerStatistics(
//       goals: json['goals'] ?? 0,
//       assists: json['assists'] ?? 0,
//       matchesPlayed: json['matchesPlayed'] ?? 0,
//       yellowCards: json['yellowCards'] ?? 0,
//       redCards: json['redCards'] ?? 0,
//       passAccuracy: json['passAccuracy']?.toDouble() ?? 0.0,
//       shotsOnTarget: json['shotsOnTarget']?.toDouble() ?? 0.0,
//       minutesPlayed: json['minutesPlayed'] ?? 0,
//       fatigueScore: json['fatigueScore']?.toDouble(), // Added parsing
//       staminaScore: json['staminaScore']?.toDouble(), // Added parsing
//     );
//   }
// }

// class MatchPerformance {
//   final String opponent;
//   final String date;
//   final int goals;
//   final int assists;
//   final double rating;
//   final int minutesPlayed;

//   MatchPerformance({
//     required this.opponent,
//     required this.date,
//     this.goals = 0,
//     this.assists = 0,
//     this.rating = 0.0,
//     this.minutesPlayed = 0,
//   });

//   factory MatchPerformance.fromJson(Map<String, dynamic> json) {
//     return MatchPerformance(
//       opponent: json['opponent'] ?? 'Unknown',
//       date: json['date'] ?? 'Unknown',
//       goals: json['goals'] ?? 0,
//       assists: json['assists'] ?? 0,
//       rating: json['rating']?.toDouble() ?? 0.0,
//       minutesPlayed: json['minutesPlayed'] ?? 0,
//     );
//   }
// }
