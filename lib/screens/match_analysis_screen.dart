import 'package:flutter/material.dart';
import '../models/player_analysis.dart';

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Match Analysis')),
      body: Column(
        children: [
          // Match score header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueGrey[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Barcelona',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '2 - 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Real Madrid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Live camera preview placeholder
          Expanded(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'LIVE MATCH FEED',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isAnalyzing ? Icons.stop : Icons.play_arrow),
                  label: Text(
                    _isAnalyzing ? 'Stop Analysis' : 'Start Analysis',
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    setState(() {
                      _isAnalyzing = !_isAnalyzing;
                    });

                    if (_isAnalyzing) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Analysis started')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.people,
                      label: 'Players',
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.sports_soccer,
                      label: 'Stats',
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed, iconSize: 32),
        Text(label),
      ],
    );
  }
}
