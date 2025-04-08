import 'package:flutter/material.dart';
import 'models/player_analysis.dart';
import 'screens/player_detail_screen.dart';

class DebugApp extends StatelessWidget {
  const DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Debug',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DebugHomePage(),
    );
  }
}

class DebugHomePage extends StatelessWidget {
  const DebugHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Debug')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is a debug app to test navigation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('Open Player Detail'),
              onPressed: () {
                final player = PlayerAnalysis.mockData();
                debugPrint('Created mock player: ${player.playerName}');

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlayerDetailScreen(player: player),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Then you can temporarily modify main.dart to run this debug app:
// void main() {
//   runApp(const DebugApp());
// }
