import 'package:flutter/material.dart';
import '../models/player_analysis.dart';
import '../screens/player_detail_screen.dart';

class DebugNavigator {
  // Function to test if the PlayerDetailScreen can be navigated to
  static void testPlayerDetailNavigation(BuildContext context) {
    debugPrint('Starting debug navigation test');
    final mockPlayer = PlayerAnalysis.mockData();

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(title: const Text('Debug Test')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Testing navigation to PlayerDetailScreen'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('Test Navigation'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      PlayerDetailScreen(player: mockPlayer),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );
    } catch (e) {
      debugPrint('Debug navigation error: $e');
    }
  }
}
