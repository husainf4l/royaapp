import 'package:flutter/material.dart';
import '../models/player_analysis.dart';

class AnalysisTipsWidget extends StatelessWidget {
  final PlayerAnalysis player;

  const AnalysisTipsWidget({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Performance Analysis & Tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildTipItem(
              'Strength',
              _getPlayerStrength(player),
              Icons.trending_up,
              Colors.green,
            ),
            _buildTipItem(
              'Area for Improvement',
              _getPlayerWeakness(player),
              Icons.trending_down,
              Colors.red,
            ),
            _buildTipItem(
              'Tactical Recommendation',
              _getTacticalTip(player),
              Icons.sports_soccer,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String label, String tip, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Text(tip),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlayerStrength(PlayerAnalysis player) {
    if (player.statistics == null) return 'No data available';

    if (player.statistics!.goals > 800) {
      return 'Exceptional goal scoring ability with consistent performance at the highest level.';
    } else if (player.statistics!.passAccuracy > 80) {
      return 'Outstanding passing accuracy, creating key opportunities for teammates.';
    } else {
      return 'Shows good overall technical ability with solid performance metrics.';
    }
  }

  String _getPlayerWeakness(PlayerAnalysis player) {
    if (player.statistics == null) return 'No data available';

    if (player.physicalCondition.toLowerCase() == 'moderate') {
      return 'Current physical condition may limit peak performance. Focus on recovery and conditioning.';
    } else if (player.statistics!.yellowCards > 100) {
      return 'Discipline issues with high number of cards. Should work on timing of challenges.';
    } else {
      return 'Could improve defensive positioning and tracking back during counterattacks.';
    }
  }

  String _getTacticalTip(PlayerAnalysis player) {
    switch (player.tacticalRole.toLowerCase()) {
      case 'forward':
        return 'Position higher up the pitch to exploit spaces between defensive lines.';
      case 'center forward':
        return 'Use strength to hold up play and bring teammates into attacking movements.';
      case 'right winger':
        return 'Cut inside more frequently to create shooting opportunities with left foot.';
      default:
        return 'Focus on maintaining tactical discipline while supporting offensive movements.';
    }
  }
}
