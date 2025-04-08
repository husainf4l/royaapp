import 'package:flutter/material.dart';
import '../models/player_analysis.dart';
import '../screens/player_detail_screen.dart';

// This is a utility file to verify imports work correctly
void verifyImports() {
  debugPrint('Verifying imports...');

  final player = PlayerAnalysis.mockData();
  final screen = PlayerDetailScreen(player: player);

  debugPrint('All imports verified successfully!');
}
