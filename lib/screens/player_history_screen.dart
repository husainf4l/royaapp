import 'package:flutter/material.dart';
import '../models/player_analysis.dart';

class PlayerHistoryScreen extends StatefulWidget {
  const PlayerHistoryScreen({super.key});

  @override
  State<PlayerHistoryScreen> createState() => _PlayerHistoryScreenState();
}

class _PlayerHistoryScreenState extends State<PlayerHistoryScreen> {
  // Mock list of past analyses
  final List<PlayerAnalysis> _history = [
    PlayerAnalysis.mockData(),
    PlayerAnalysis.mockData(),
    PlayerAnalysis.mockData(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis History'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final analysis = _history[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(analysis.playerName),
              subtitle: Text(
                '${analysis.physicalCondition} • ${analysis.tacticalRole}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // View detailed analysis
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          // Return to camera screen
          Navigator.pop(context);
        },
      ),
    );
  }
}
