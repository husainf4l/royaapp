import 'package:flutter/material.dart';
import '../models/player_analysis.dart';
import '../screens/player_detail_screen.dart';

class AnalysisHistoryScreen extends StatefulWidget {
  const AnalysisHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisHistoryScreen> createState() => _AnalysisHistoryScreenState();
}

class _AnalysisHistoryScreenState extends State<AnalysisHistoryScreen> {
  // This would normally come from a database or API
  final List<PlayerAnalysis> _analysisHistory = [
    PlayerAnalysis.mockData(),
    PlayerAnalysis.mockData(),
    PlayerAnalysis.mockData(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      body:
          _analysisHistory.isEmpty
              ? const Center(child: Text('No analysis history yet'))
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _analysisHistory.length,
                itemBuilder: (context, index) {
                  final player = _analysisHistory[index];
                  return _buildAnalysisHistoryCard(player);
                },
              ),
    );
  }

  Widget _buildAnalysisHistoryCard(PlayerAnalysis player) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerDetailScreen(player: player),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Player image
              if (player.playerImageUrl != null)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(player.playerImageUrl!),
                )
              else
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
              const SizedBox(width: 16),
              // Player info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.playerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      player.tacticalRole,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.fiber_manual_record,
                          size: 12,
                          color: _getConditionColor(player.physicalCondition),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          player.physicalCondition,
                          style: TextStyle(
                            color: _getConditionColor(player.physicalCondition),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Team badge
              if (player.teamName != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    player.teamName!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'moderate':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
