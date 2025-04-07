import 'package:flutter/material.dart';

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelName;
  final String viewCount;
  final String publishedTime;
  final String duration;
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelName,
    required this.viewCount,
    required this.publishedTime,
    required this.duration,
    required this.videoUrl,
  });
}

class SmartReplayScreen extends StatefulWidget {
  const SmartReplayScreen({super.key});

  @override
  State<SmartReplayScreen> createState() => _SmartReplayScreenState();
}

class _SmartReplayScreenState extends State<SmartReplayScreen> {
  String _selectedFilter = 'الكل';

  final List<String> _filters = [
    'الكل',
    'اللاعبين',
    'زوايا الكاميرا',
    'الأهداف',
    'ركلات الجزاء',
  ];

  final List<VideoModel> _videos = [
    VideoModel(
      id: '1',
      title: 'أفضل أهداف الدوري هذا الأسبوع',
      description:
          'شاهد أجمل الأهداف التي سجلت في مباريات الدوري لهذا الأسبوع مع تحليل فني للقطات',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',
      channelName: 'رؤيا سبورت',
      viewCount: '1.2 مليون مشاهدة',
      publishedTime: 'قبل يومين',
      duration: '8:45',
      videoUrl: 'https://www.youtube.com/watch?v=example1',
    ),
    VideoModel(
      id: '2',
      title: 'مهارات استثنائية من نجم الفريق',
      description:
          'لقطات حصرية تظهر المهارات الرائعة التي قدمها النجم خلال المباراة الأخيرة',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',
      channelName: 'نجوم الكرة',
      viewCount: '875 ألف مشاهدة',
      publishedTime: 'قبل 3 أيام',
      duration: '5:21',
      videoUrl: 'https://www.youtube.com/watch?v=example2',
    ),
    VideoModel(
      id: '3',
      title: 'جميع ركلات الجزاء في الجولة الأخيرة',
      description:
          'تجميع لجميع ركلات الجزاء التي احتسبت في مباريات الجولة الأخيرة مع تحليل لقرارات الحكام',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',

      channelName: 'تحليل تحكيمي',
      viewCount: '650 ألف مشاهدة',
      publishedTime: 'قبل يوم',
      duration: '12:30',
      videoUrl: 'https://www.youtube.com/watch?v=example3',
    ),
    VideoModel(
      id: '4',
      title: 'تصديات حارس المرمى الاستثنائية',
      description:
          'لقطات تبرز براعة حارس المرمى في التصدي للكرات الخطيرة وإنقاذ فريقه من أهداف محققة',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',

      channelName: 'أساطير الحراسة',
      viewCount: '1.4 مليون مشاهدة',
      publishedTime: 'قبل 4 أيام',
      duration: '7:20',
      videoUrl: 'https://www.youtube.com/watch?v=example4',
    ),
    VideoModel(
      id: '5',
      title: 'زوايا كاميرا خاصة للهدف القاتل',
      description:
          'شاهد الهدف القاتل في الدقائق الأخيرة من زوايا مختلفة للكاميرا تظهر روعة التسديدة',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',

      channelName: 'عشاق الساحرة المستديرة',
      viewCount: '2.3 مليون مشاهدة',
      publishedTime: 'قبل أسبوع',
      duration: '4:15',
      videoUrl: 'https://www.youtube.com/watch?v=example5',
    ),
    VideoModel(
      id: '6',
      title: 'أجمل المراوغات في الدوري',
      description:
          'مجموعة من أجمل المراوغات والمهارات الفنية التي قدمها اللاعبون في مباريات هذا الموسم',
      thumbnailUrl:
          'https://www.reuters.com/resizer/v2/3BCEKYL67NLCXIJXCFCRNCXWF4.jpg?auth=0647b339f4febcbf051e9623235c494499133a0bc65836220e72cfd0896d9095&width=1080&quality=80',

      channelName: 'فن الكرة',
      viewCount: '980 ألف مشاهدة',
      publishedTime: 'قبل 5 أيام',
      duration: '10:10',
      videoUrl: 'https://www.youtube.com/watch?v=example6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter categories
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Divider between filter and content

          // Video content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return VideoCard(video: video);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoModel video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail with duration
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: NetworkImage(video.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video.duration,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // Video details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[400],
                  child: Text(
                    video.channelName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),

                // Video title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${video.channelName} • ${video.viewCount} • ${video.publishedTime}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Options icon
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show options menu
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
