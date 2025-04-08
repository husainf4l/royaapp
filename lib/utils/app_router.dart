import 'package:flutter/material.dart';
import '../screens/ar_player_analysis_screen.dart';
import '../screens/player_detail_screen.dart';
import '../screens/team_analysis_screen.dart';
import '../screens/match_analysis_screen.dart';
import '../models/player_analysis.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const ARPlayerAnalysisScreen(),
        );

      case '/player-detail':
        final player = settings.arguments as PlayerAnalysis;
        return MaterialPageRoute(
          builder: (_) => PlayerDetailScreen(player: player),
        );

      case '/team-analysis':
        final teamName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TeamAnalysisScreen(teamName: teamName),
        );

      case '/match-analysis':
        return MaterialPageRoute(builder: (_) => const MatchAnalysisScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
