import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:royaapp/widgets/player_live.dart';
import 'package:royaapp/services/live_player_service.dart';

class StoryCircles extends StatefulWidget {
  const StoryCircles({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StoryCirclesState createState() => _StoryCirclesState();
}

class _StoryCirclesState extends State<StoryCircles> {
  final LivePlayerService _livePlayerService =
      LivePlayerService(); // Replace with actual base URL
  List<dynamic> _livePlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLivePlayers();
  }

  Future<void> _fetchLivePlayers() async {
    try {
      final players = await _livePlayerService.fetchLivePlayers();
      setState(() {
        _livePlayers = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching live players: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _livePlayers.length,
      itemBuilder: (context, index) {
        final player = _livePlayers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerLive(storyIndex: 1),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                player['imageUrl'], // Use player's image URL
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
