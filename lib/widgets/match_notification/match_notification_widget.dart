import 'package:flutter/material.dart';

class MatchNotificationWidget extends StatelessWidget {
  const MatchNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image container with match time
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/hero1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Overlay with gradient for better text visibility
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),

              // Team logo overlay
              Positioned(
                top: 10,
                right: 10,
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/en/thumb/a/ac/Al_Nassr_FC_Logo.svg/1200px-Al_Nassr_FC_Logo.svg.png',
                  height: 60,
                  width: 60,
                ),
              ),

              // Match information with Arabic text
              Positioned(
                bottom: 20,
                right: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      'المباراة القادمة تبدأ في',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '30 دقيقة',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Match details and stats section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Match location
              const Text(
                'ملعب الملك فهد الدولي، المملكة العربية السعودية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),

              const SizedBox(height: 16),

              // Statistics bars
              _buildStatBar(
                context: context,
                label: 'الإستحواذ في آخر 5 مباريات',
                team1Value: 88,
                team2Value: 20,
                team1Name: 'الهلال',
                team2Name: 'النصر',
              ),

              const SizedBox(height: 12),

              _buildStatBar(
                context: context,
                label: ' التسديدات في آخر 5 مباريات',
                team1Value: 50,
                team2Value: 50,
                isPercentage: false,
                team1Name: 'الهلال',
                team2Name: 'النصر',
              ),

              const SizedBox(height: 12),

              _buildStatBar(
                context: context,
                label: 'الفوز في آخر 5 مباريات',
                team1Value: 20,
                team2Value: 80,
                isPercentage: false,
                team1Name: 'الهلال',
                team2Name: 'النصر',
              ),

              const SizedBox(height: 16),

              // Team analysis
              const Text(
                'تحليل الفريقين: النصر يتفوق بنسبة استحواذ 60% في آخر 5 مباريات',
                style: TextStyle(color: Colors.white, fontSize: 14),
                textDirection: TextDirection.rtl,
              ),

              const SizedBox(height: 8),

              // Team lineup
              const Text(
                'تشكيلة الفريقين: يغيب كريستيانو رونالدو للإصابة، ويعود طلال العبسي للتشكيلة الأساسية',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textDirection: TextDirection.rtl,
              ),

              const SizedBox(height: 8),

              // Top scorers
              const Text(
                'الهدافين: سالم الدوسري (8 أهداف) - أندرسون تاليسكا (6 أهداف)',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar({
    required BuildContext context,
    required String label,
    required double team1Value,
    required double team2Value,
    required String team1Name,
    required String team2Name,
    bool isPercentage = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // Team 1 name
            Text(
              team1Name,
              style: const TextStyle(color: Colors.lightBlue, fontSize: 12),
            ),
            const SizedBox(width: 8),

            // Team 1 value
            Text(
              isPercentage ? "${team1Value.toInt()}%" : "${team1Value.toInt()}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 8),

            // Stat bar
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(
                        flex: team1Value.toInt(),
                        child: Container(color: Colors.blue),
                      ),
                      Expanded(
                        flex: team2Value.toInt(),
                        child: Container(color: Colors.amber),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Team 2 value
            Text(
              isPercentage ? "${team2Value.toInt()}%" : "${team2Value.toInt()}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 8),

            // Team 2 name
            Text(
              team2Name,
              style: const TextStyle(color: Colors.amber, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
