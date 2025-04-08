import 'package:flutter/material.dart';
import '../models/player_analysis.dart';

class PlayerDetailScreen extends StatelessWidget {
  final PlayerAnalysis player;

  const PlayerDetailScreen({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.playerName),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player image
            if (player.playerImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  player.playerImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[800],
                width: double.infinity,
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white54, size: 64),
                ),
              ),

            const SizedBox(height: 16),

            // Basic info
            Text(
              player.playerName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow("Role", player.tacticalRole),
            _buildInfoRow("Physical Condition", player.physicalCondition),
            if (player.teamName != null)
              _buildInfoRow("Team", player.teamName!),
            if (player.nationality != null)
              _buildInfoRow("Nationality", player.nationality!),

            const SizedBox(height: 24),

            // Statistics section
            const Text(
              "STATISTICS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (player.statistics != null) ...[
              _buildStatRow("Goals", player.statistics!.goals.toString()),
              _buildStatRow("Assists", player.statistics!.assists.toString()),
              _buildStatRow(
                "Matches Played",
                player.statistics!.matchesPlayed.toString(),
              ),
            ] else
              const Text("No statistics available"),

            const SizedBox(height: 24),

            // Videos section
            const Text(
              "VIDEOS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (player.videoReplayLinks != null &&
                player.videoReplayLinks!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: player.videoReplayLinks!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle),
                      title: Text("Replay ${index + 1}"),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Playing video ${index + 1}")),
                        );
                      },
                    ),
                  );
                },
              )
            else
              const Text("No videos available"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
