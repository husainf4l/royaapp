import 'package:flutter/material.dart';
import '../models/player_analysis.dart';
import '../screens/player_detail_screen.dart';
import '../screens/team_analysis_screen.dart';

class PlayerAnalysisCard extends StatefulWidget {
  final PlayerAnalysis playerAnalysis;
  final VoidCallback onClose;

  const PlayerAnalysisCard({
    Key? key,
    required this.playerAnalysis,
    required this.onClose,
  }) : super(key: key);

  @override
  State<PlayerAnalysisCard> createState() => _PlayerAnalysisCardState();
}

class _PlayerAnalysisCardState extends State<PlayerAnalysisCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with name and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.playerAnalysis.playerImageUrl != null
                      ? Row(
                        children: [
                          Hero(
                            tag: 'player-${widget.playerAnalysis.playerName}',
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.playerAnalysis.playerImageUrl!,
                              ),
                              radius: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.playerAnalysis.playerName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        widget.playerAnalysis.playerName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      // Add a fade out animation before closing
                      _controller.reverse().then((_) => widget.onClose());
                    },
                  ),
                ],
              ),

              const Divider(color: Colors.white30, thickness: 1),

              // Player information
              _buildInfoRow(
                'Condition',
                widget.playerAnalysis.physicalCondition,
              ),
              _buildInfoRow('Role', widget.playerAnalysis.tacticalRole),

              // Video links if available
              if (widget.playerAnalysis.videoReplayLinks != null &&
                  widget.playerAnalysis.videoReplayLinks!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Video Replays',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.playerAnalysis.videoReplayLinks!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: OutlinedButton.icon(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Replay ${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Playing video: ${widget.playerAnalysis.videoReplayLinks![index]}',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Action buttons
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.playerAnalysis.teamName != null)
                    _buildActionButton(
                      icon: Icons.groups,
                      label: 'Team',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TeamAnalysisScreen(
                                  teamName: widget.playerAnalysis.teamName!,
                                ),
                          ),
                        );
                      },
                    ),
                  _buildActionButton(
                    icon: Icons.account_circle,
                    label: 'Profile',
                    onPressed: () {
                      debugPrint(
                        'Opening profile for ${widget.playerAnalysis.playerName}',
                      );

                      // Add try-catch for more robust error handling
                      try {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PlayerDetailScreen(
                                      player: widget.playerAnalysis,
                                    ),
                              ),
                            )
                            .then((_) {
                              debugPrint('Returned from player detail screen');
                            })
                            .catchError((error) {
                              debugPrint('Navigation error: $error');
                            });
                      } catch (e) {
                        debugPrint('Error navigating to player details: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error showing player profile: $e'),
                          ),
                        );
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sharing player analysis...'),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('More options...')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
