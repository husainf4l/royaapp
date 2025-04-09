import 'package:flutter/material.dart';
import 'package:royaapp/widgets/player_analysis_card.dart';
import '../widgets/ar_player_analysis_screen.dart';
import '../services/live_player_service.dart';
import '../models/live_player.dart';
import '../models/player.dart';
import '../models/player_analysis.dart';

class AICommentatorSettingsScreen extends StatefulWidget {
  const AICommentatorSettingsScreen({super.key});

  @override
  State<AICommentatorSettingsScreen> createState() =>
      _AICommentatorSettingsScreenState();
}

class _AICommentatorSettingsScreenState
    extends State<AICommentatorSettingsScreen> {
  final LivePlayerService _livePlayerService = LivePlayerService();
  List<Player> players = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    print("-------------------------  ");
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      print("----------------------2---  ");

      final playersData = await _livePlayerService.fetchLivePlayers();

      // Convert the raw data to Player objects
      List<Player> fetchedPlayers = [];
      for (var playerData in playersData) {
        if (playerData['player'] != null) {
          // Extract player data from the nested structure
          fetchedPlayers.add(Player.fromJson(playerData['player']));
        } else {
          // If 'player' key doesn't exist, assume the object itself is a player
          fetchedPlayers.add(Player.fromJson(playerData));
        }
      }

      print("Number of players fetched: ${fetchedPlayers.length}");
      print("----------------------4--- ");

      setState(() {
        players = fetchedPlayers;
        if (players.isEmpty) {
          errorMessage = 'No players available';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load players: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.blue, width: 3),
                  ),
                  padding: const EdgeInsets.all(40),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ARPlayerAnalysisScreen(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.grey, size: 60),
                    SizedBox(height: 8),
                    Text(
                      'Open Camera to scan a player',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Available Players',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                      : players.isEmpty
                      ? const Center(child: Text('No players available'))
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];
                          return GestureDetector(
                            onTap: () {
                              if (player.performances.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PlayerAnalysisCard(
                                          playerAnalysis:
                                              player.performances.first,
                                          onClose: () {},
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        player.imageUrl != null
                                            ? NetworkImage(player.imageUrl!)
                                            : null,
                                    child:
                                        player.imageUrl == null
                                            ? Text(
                                              player.name.substring(0, 1),
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            )
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  player.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
