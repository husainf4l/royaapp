import 'package:flutter/material.dart';
import '../models/player_analysis.dart';
import '../screens/player_detail_screen.dart';
import '../screens/team_analysis_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerAnalysisCard extends StatefulWidget {
  final PlayerAnalysis playerAnalysis;
  final VoidCallback onClose;

  const PlayerAnalysisCard({
    super.key,
    required this.playerAnalysis,
    required this.onClose,
  });

  @override
  State<PlayerAnalysisCard> createState() => _PlayerAnalysisCardState();
}

class _PlayerAnalysisCardState extends State<PlayerAnalysisCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int _currentTabIndex = 0;
  final List<String> _tabTitles = [
    'Overview',
    'Physical',
    'Technical',
    'Heatmap',
  ];
  bool _expanded = false;

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
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swipe up
              setState(() => _expanded = true);
            } else if (details.primaryVelocity! > 0) {
              // Swipe down
              setState(() => _expanded = false);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: _expanded ? MediaQuery.of(context).size.height * 0.8 : null,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
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
              mainAxisSize: _expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                // Drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Header with player info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.playerAnalysis.playerImageUrl != null
                        ? Row(
                          children: [
                            Hero(
                              tag: 'player-${widget.playerAnalysis.playerName}',
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.playerAnalysis.playerImageUrl!,
                                ),
                                radius: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.playerAnalysis.playerName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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
                    Row(
                      children: [
                        if (widget.playerAnalysis.number != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '#${widget.playerAnalysis.number}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            _controller.reverse().then((_) => widget.onClose());
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(color: Colors.white30, thickness: 1),

                // If expanded, show tabs and detailed content
                if (_expanded) ...[
                  // Tab navigation
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tabTitles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => _currentTabIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color:
                                  _currentTabIndex == index
                                      ? Colors.blue.withOpacity(0.8)
                                      : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _tabTitles[index],
                              style: TextStyle(
                                color:
                                    _currentTabIndex == index
                                        ? Colors.white
                                        : Colors.white70,
                                fontWeight:
                                    _currentTabIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tab content
                  Expanded(child: _buildTabContent(_currentTabIndex)),
                ] else ...[
                  // Show basic info when collapsed
                  _buildQuickStatsSection(),

                  const SizedBox(height: 10),

                  // Show hint to expand
                  Center(
                    child: Text(
                      'Swipe up for detailed analysis',
                      style: TextStyle(color: Colors.blue[200], fontSize: 12),
                    ),
                  ),
                ],

                // Action buttons
                const SizedBox(height: 12),
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
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PlayerDetailScreen(
                                    player: widget.playerAnalysis,
                                  ),
                            ),
                          );
                        } catch (e) {
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
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0: // Overview
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPerformanceScoreCard(),
              const SizedBox(height: 16),
              _buildQuickStatsSection(),
              const SizedBox(height: 16),
              _buildActionableInsights(),
            ],
          ),
        );
      case 1: // Physical
        return _buildPhysicalStatsTab();
      case 2: // Technical
        return _buildTechnicalStatsTab();
      case 3: // Heatmap
        return _buildHeatmapTab();
      default:
        return const Center(
          child: Text(
            'Tab content not available',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildPerformanceScoreCard() {
    final fatigueScore = widget.playerAnalysis.fatigueScore ?? 0.0;
    final staminaScore = widget.playerAnalysis.staminaScore ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Scores',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularProgressIndicator(
                'Fatigue',
                fatigueScore,
                color: fatigueScore > 0.7 ? Colors.red : Colors.green,
              ),
              _buildCircularProgressIndicator(
                'Stamina',
                staminaScore,
                color: staminaScore < 0.3 ? Colors.red : Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgressIndicator(
    String label,
    double value, {
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildQuickStatsSection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildStatChip(
          Icons.speed,
          'Top Speed',
          '${widget.playerAnalysis.topSpeed?.toStringAsFixed(1) ?? "N/A"} km/h',
        ),
        _buildStatChip(
          Icons.directions_run,
          'Distance',
          '${widget.playerAnalysis.distanceKm?.toStringAsFixed(2) ?? "N/A"} km',
        ),
        _buildStatChip(
          Icons.bolt,
          'Sprints',
          '${widget.playerAnalysis.sprintCount ?? "N/A"}',
        ),
        _buildStatChip(
          Icons.favorite,
          'Avg HR',
          '${widget.playerAnalysis.heartRateAvg ?? "N/A"} bpm',
        ),
        _buildStatChip(
          Icons.sports_soccer,
          'Passes',
          '${widget.playerAnalysis.passesCompleted ?? "N/A"}',
        ),
        _buildStatChip(
          Icons.trending_up,
          'Accelerations',
          '${widget.playerAnalysis.accelerations ?? "N/A"}',
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue[300], size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionableInsights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            // Generate insights based on performance data
            _generateInsights(),
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
        ],
      ),
    );
  }

  String _generateInsights() {
    final insights = <String>[];

    // Fatigue insights
    if (widget.playerAnalysis.fatigueScore != null) {
      if (widget.playerAnalysis.fatigueScore! > 0.8) {
        insights.add(
          'Player is showing signs of high fatigue. Consider rest period.',
        );
      }
    }

    // Speed insights
    if (widget.playerAnalysis.topSpeed != null &&
        widget.playerAnalysis.topSpeed! > 30) {
      insights.add('Exceptional top speed performance.');
    }

    // Heart rate insights
    if (widget.playerAnalysis.heartRateAvg != null &&
        widget.playerAnalysis.heartRateMax != null) {
      if (widget.playerAnalysis.heartRateMax! > 180) {
        insights.add(
          'Player reached high heart rate zones during performance.',
        );
      }
    }

    // Technical insights
    if (widget.playerAnalysis.passesCompleted != null &&
        widget.playerAnalysis.passesCompleted! > 25) {
      insights.add(
        'Good passing performance with ${widget.playerAnalysis.passesCompleted} completed passes.',
      );
    }

    // If we have some insights, join them, otherwise provide a default message
    if (insights.isNotEmpty) {
      return insights.join('\n\n');
    }
    return 'Insufficient data to generate meaningful insights for this player.';
  }

  Widget _buildPhysicalStatsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Speed chart
          if (widget.playerAnalysis.topSpeed != null &&
              widget.playerAnalysis.avgSpeed != null)
            _buildSpeedComparisonChart(),

          const SizedBox(height: 20),

          // Heart rate section
          if (widget.playerAnalysis.heartRateAvg != null &&
              widget.playerAnalysis.heartRateMax != null)
            _buildHeartRateSection(),

          const SizedBox(height: 20),

          // Temperature and endurance stats
          _buildMedicalStatsSection(),
        ],
      ),
    );
  }

  Widget _buildSpeedComparisonChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speed Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 35,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        if (value == 0) text = 'Top Speed';
                        if (value == 1) text = 'Avg Speed';
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: widget.playerAnalysis.topSpeed ?? 0,
                        color: Colors.blue,
                        width: 25,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: widget.playerAnalysis.avgSpeed ?? 0,
                        color: Colors.lightBlue,
                        width: 25,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Distance: ${widget.playerAnalysis.distanceKm?.toStringAsFixed(2) ?? "N/A"} km',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(
                'Sprints: ${widget.playerAnalysis.sprintCount ?? "N/A"}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Heart Rate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeartRateIndicator(
                'Average',
                widget.playerAnalysis.heartRateAvg ?? 0,
                Colors.green,
              ),
              _buildHeartRateIndicator(
                'Maximum',
                widget.playerAnalysis.heartRateMax ?? 0,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateIndicator(String label, int value, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.favorite, size: 70, color: color.withOpacity(0.3)),
              Text(
                '$value',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          'BPM',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMedicalStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical & Endurance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMedicalStatItem(
                'Body Temp',
                '${widget.playerAnalysis.bodyTempC?.toStringAsFixed(1) ?? "N/A"}°C',
                Icons.thermostat,
              ),
              _buildMedicalStatItem(
                'Fatigue',
                '${(widget.playerAnalysis.fatigueScore != null ? widget.playerAnalysis.fatigueScore! * 100 : 0).toInt()}%',
                Icons.battery_alert,
              ),
              _buildMedicalStatItem(
                'Stamina',
                '${(widget.playerAnalysis.staminaScore != null ? widget.playerAnalysis.staminaScore! * 100 : 0).toInt()}%',
                Icons.fitness_center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[300], size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTechnicalStatsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTechnicalStatsOverview(),
          const SizedBox(height: 20),
          _buildTechnicalPerformanceRadar(),
        ],
      ),
    );
  }

  Widget _buildTechnicalStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technical Stats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildTechnicalStatItem(
                'Passes',
                widget.playerAnalysis.passesCompleted ?? 0,
              ),
              _buildTechnicalStatItem(
                'Shots',
                widget.playerAnalysis.shotsOnTarget ?? 0,
              ),
              _buildTechnicalStatItem(
                'Interceptions',
                widget.playerAnalysis.interceptions ?? 0,
              ),
              _buildTechnicalStatItem(
                'Tackles',
                widget.playerAnalysis.tackles ?? 0,
              ),
              _buildTechnicalStatItem(
                'Accelerations',
                widget.playerAnalysis.accelerations ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalStatItem(String label, int value) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalPerformanceRadar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Position Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              widget.playerAnalysis.position ?? 'Position: N/A',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Position-specific performance metrics coming soon',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Player Movement Heatmap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child:
              widget.playerAnalysis.heatmapUrl != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.playerAnalysis.heatmapUrl!,
                      fit: BoxFit.contain,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) => const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Could not load heatmap',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                    ),
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: Colors.grey[600],
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No heatmap available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
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
