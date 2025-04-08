import 'package:flutter/material.dart';
import '../models/player_analysis.dart';

class TeamAnalysisScreen extends StatefulWidget {
  final String teamName;

  const TeamAnalysisScreen({Key? key, required this.teamName})
    : super(key: key);

  @override
  State<TeamAnalysisScreen> createState() => _TeamAnalysisScreenState();
}

class _TeamAnalysisScreenState extends State<TeamAnalysisScreen> {
  List<PlayerAnalysis> _teamPlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamPlayers();
  }

  Future<void> _loadTeamPlayers() async {
    // Simulate API fetch with delay
    await Future.delayed(const Duration(seconds: 1));

    // Create mock data for team players
    final players = [
      PlayerAnalysis.mockData(),
      PlayerAnalysis.mockData(),
      PlayerAnalysis.mockData(),
    ];

    if (mounted) {
      setState(() {
        _teamPlayers = players;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.teamName} Analysis')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Team overview card
                  _buildTeamOverviewCard(),

                  const SizedBox(height: 16),

                  // Team players section
                  const Text(
                    'Team Players',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Players list
                  ..._teamPlayers
                      .map((player) => _buildPlayerCard(player))
                      .toList(),
                ],
              ),
    );
  }

  Widget _buildTeamOverviewCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.teamName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Team Statistics'),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TeamStatItem(label: 'Wins', value: '16'),
                _TeamStatItem(label: 'Draws', value: '5'),
                _TeamStatItem(label: 'Losses', value: '3'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TeamStatItem(label: 'Goals For', value: '45'),
                _TeamStatItem(label: 'Goals Against', value: '23'),
                _TeamStatItem(label: 'Clean Sheets', value: '9'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(PlayerAnalysis player) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              player.playerImageUrl != null
                  ? NetworkImage(player.playerImageUrl!)
                  : null,
          child:
              player.playerImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(player.playerName),
        subtitle: Text(player.tacticalRole),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to player detail
          Navigator.pushNamed(context, '/player-detail', arguments: player);
        },
      ),
    );
  }
}

class _TeamStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _TeamStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
