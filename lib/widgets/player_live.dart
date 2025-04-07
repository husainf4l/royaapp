import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerLive extends StatefulWidget {
  final int storyIndex;

  const PlayerLive({super.key, required this.storyIndex});

  @override
  _PlayerLiveState createState() => _PlayerLiveState();
}

class _PlayerLiveState extends State<PlayerLive> with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool showHealth = false;
  bool showSpeed = false;
  bool showScore = false;

  // Animation controllers for AI-like data display
  late AnimationController _healthAnimController;
  late AnimationController _speedAnimController;
  late AnimationController _scoreAnimController;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.asset(
          'assets/images/b.mov', // Ensure this path is correct
        )
        ..initialize()
            .then((_) {
              setState(
                () {},
              ); // Refresh the widget once the video is initialized
              _controller.play(); // Auto-play the video
              _controller.setLooping(true); // Loop the video
            })
            .catchError((error) {
              debugPrint('Error initializing video player: $error');
            });
    } catch (e) {
      debugPrint('Exception caught during video initialization: $e');
    }

    // Initialize animation controllers
    _healthAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _speedAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scoreAnimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    _healthAnimController.dispose();
    _speedAnimController.dispose();
    _scoreAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? SizedBox.expand(
                // Make the video cover the entire screen
                child: FittedBox(
                  fit: BoxFit.cover, // Ensures the video covers the screen
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
              : Center(
                child: CircularProgressIndicator(),
              ), // Show a loader until the video is ready
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Overlay for player name - Instagram style
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black38],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white30, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey[800],
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'johndoe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 10),
                  ),
                ],
              ),
            ),
          ),
          // AI-powered metrics overlays
          if (showHealth) _buildHealthOverlay(),
          if (showSpeed) _buildSpeedOverlay(),
          if (showScore) _buildScoreOverlay(),
          // Buttons to add text overlays at bottom
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOverlayButton(
                  'Health',
                  Icons.favorite,
                  Colors.red,
                  showHealth,
                ),
                _buildOverlayButton(
                  'Speed',
                  Icons.speed,
                  Colors.blue,
                  showSpeed,
                ),
                _buildOverlayButton(
                  'Score',
                  Icons.star,
                  Colors.amber,
                  showScore,
                ),
              ],
            ),
          ),
          // Instagram-like interaction buttons on the right
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                _buildInteractionButton(Icons.bookmark_border, ''),
                _buildInteractionButton(Icons.more_horiz, ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton(
    String label,
    IconData icon,
    Color color,
    bool isActive,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isActive
                  ? [color.withOpacity(0.7), color.withOpacity(0.5)]
                  : [Colors.black54, Colors.black45],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isActive ? color.withOpacity(0.7) : Colors.white24,
          width: 0.5,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            switch (label) {
              case 'Health':
                showHealth = !showHealth;
                break;
              case 'Speed':
                showSpeed = !showSpeed;
                break;
              case 'Score':
                showScore = !showScore;
                break;
            }
          });
        },
        icon: Icon(icon, color: isActive ? Colors.white : color, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildHealthOverlay() {
    return Positioned(
      top: 120,
      left: 20,
      child: AnimatedBuilder(
        animation: _healthAnimController,
        builder: (context, child) {
          final health = 85 + (_healthAnimController.value * 5);
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "HEALTH ANALYTICS",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "${health.toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OPTIMAL",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "CONDITION",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: 180,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: health / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "AI ANALYSIS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpeedOverlay() {
    return Positioned(
      top: 250,
      left: 20,
      child: AnimatedBuilder(
        animation: _speedAnimController,
        builder: (context, child) {
          final speed = 12 + (_speedAnimController.value * 4);
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "SPEED METRICS",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "${speed.toStringAsFixed(1)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "m/s",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      speed > 14 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: speed > 14 ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "AI POWERED TRACKING",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreOverlay() {
    return Positioned(
      top: 350,
      left: 20,
      child: AnimatedBuilder(
        animation: _scoreAnimController,
        builder: (context, child) {
          final baseScore = 720;
          final variation = (50 * _scoreAnimController.value).toInt();
          final score = baseScore + variation;

          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "PERFORMANCE SCORE",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "$score",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    _buildScoreStar(),
                    _buildScoreStar(),
                    _buildScoreStar(),
                    _buildScoreStar(filled: score > 750),
                    _buildScoreStar(filled: score > 800),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "AI ASSESSMENT",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreStar({bool filled = true}) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      color: Colors.amber,
      size: 14,
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8, top: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        if (count.isNotEmpty)
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (count.isNotEmpty) SizedBox(height: 4),
      ],
    );
  }
}
