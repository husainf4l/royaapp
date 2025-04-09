import 'package:flutter/material.dart';
import 'package:royaapp/widgets/player_live.dart';
import 'package:royaapp/widgets/story_circles.dart';

// Model class for stadium spots
class StadiumSpot {
  final String title;
  final String description;
  final String imageUrl;
  final bool isVIP;
  final int id;

  StadiumSpot({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isVIP = false,
  });
}

class LiveViewScreen extends StatelessWidget {
  LiveViewScreen({super.key});

  // List of available stadium spots (will be fetched from API later)
  final List<StadiumSpot> stadiumSpots = [
    StadiumSpot(
      id: 11,
      title: "الجانب الشمالي",
      description: "إطلالة مميزة على كامل الملعب",
      imageUrl:
          "https://images.unsplash.com/photo-1563299796-b729d0af54a5?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    StadiumSpot(
      id: 12,
      title: "المقصورة الرئيسية",
      description: "أفضل مشاهدة للمباراة",
      imageUrl:
          "https://images.unsplash.com/photo-1522778590545-a5a925dcf6f5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      isVIP: true,
    ),
    StadiumSpot(
      id: 13,
      title: "خلف المرمى",
      description: "شاهد تسجيل الأهداف من قرب",
      imageUrl:
          "https://images.unsplash.com/photo-1563299796-b729d0af54a5?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
    StadiumSpot(
      id: 14,
      title: "الجانب الجنوبي",
      description: "بجانب مشجعي الفريق",
      imageUrl:
          "https://images.unsplash.com/photo-1607627000458-210e8d2bdb1d?q=80&w=2049&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اللاعبون المتواجدون الآن',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 100, child: StoryCircles()),
                const SizedBox(height: 10),

                // Secondary Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'هل تفضل مكان 360 آخر؟',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Stadium spots list
                const SizedBox(height: 16),
                ...stadiumSpots.map(
                  (spot) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: StadiumSpotCard(spot: spot),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StadiumSpotCard extends StatelessWidget {
  final StadiumSpot spot;

  const StadiumSpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to PlayerLive screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerLive(storyIndex: spot.id),
          ),
        );
        print(spot.id);
      },
      child: Container(
        width: double.infinity,
        height: 220, // Fixed height for the card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: spot.isVIP ? Colors.amber : Colors.grey[300]!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                spot.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),

              // Dark overlay gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Content overlay
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Title with VIP indicator if applicable
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            spot.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        if (spot.isVIP)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      spot.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),

                    const Spacer(),

                    // View button - removed available spots text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to PlayerLive screen directly from button
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PlayerLive(storyIndex: spot.id),
                            ),
                          );
                          print(spot.id);
                        },
                        icon: const Icon(Icons.videocam),
                        label: const Text('مشاهدة البث'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              spot.isVIP ? Colors.amber : Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
