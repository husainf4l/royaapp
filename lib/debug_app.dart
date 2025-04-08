import 'package:flutter/material.dart';
import 'models/player_analysis.dart';
import 'screens/player_detail_screen.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Debug',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DebugHomePage(),
    );
  }
}

class DebugHomePage extends StatefulWidget {
  const DebugHomePage({super.key});

  @override
  State<DebugHomePage> createState() => _DebugHomePageState();
}

class _DebugHomePageState extends State<DebugHomePage> {
  String _codeStats = "Press 'Count Lines' to analyze codebase";
  bool _isLoading = false;

  Future<void> _countLinesOfCode() async {
    setState(() {
      _isLoading = true;
      _codeStats = "Counting lines of code...";
    });

    try {
      final result = await _analyzeCodebase();
      setState(() {
        _codeStats = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _codeStats = "Error counting lines: $e";
        _isLoading = false;
      });
    }
  }

  Future<String> _analyzeCodebase() async {
    final projectDir = Directory('/Users/al-husseinabdullah/Desktop/royaapp');

    if (!await projectDir.exists()) {
      return "Project directory not found";
    }

    int totalFiles = 0;
    int totalLines = 0;
    Map<String, int> extensionCounts = {};

    await for (FileSystemEntity entity in projectDir.list(recursive: true)) {
      if (entity is File) {
        final ext = path.extension(entity.path).toLowerCase();

        // Skip build directory and hidden files
        if (entity.path.contains('/build/') ||
            entity.path.contains('/.') ||
            entity.path.contains('.git/')) {
          continue;
        }

        // Count only relevant file types
        if ([
          '.dart',
          '.swift',
          '.java',
          '.kt',
          '.h',
          '.m',
          '.gradle',
          '.yaml',
          '.json',
        ].contains(ext)) {
          totalFiles++;

          try {
            final content = await entity.readAsString();
            final lineCount = content.split('\n').length;
            totalLines += lineCount;

            extensionCounts[ext] = (extensionCounts[ext] ?? 0) + lineCount;
          } catch (e) {
            // Skip files that can't be read as text
          }
        }
      }
    }

    // Build the result message
    final buffer = StringBuffer();
    buffer.writeln('Total Files: $totalFiles');
    buffer.writeln('Total Lines: $totalLines');
    buffer.writeln('\nBreakdown by file type:');

    extensionCounts.forEach((ext, lines) {
      buffer.writeln('$ext: $lines lines');
    });

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is a debug app to test navigation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Code stats display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code Statistics:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                        _codeStats,
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _countLinesOfCode,
                  child: const Text('Count Lines'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  child: const Text('Open Player Detail'),
                  onPressed: () {
                    final player = PlayerAnalysis.mockData();
                    debugPrint('Created mock player: ${player.playerName}');

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => PlayerDetailScreen(player: player),
                      ),
                    );
                  },
                ),
              ],
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
