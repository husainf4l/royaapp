import 'package:flutter/material.dart';
import 'package:royaapp/widgets/match_notification/match_notification_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: const [MatchNotificationWidget()]),
      ),
    );
  }
}
