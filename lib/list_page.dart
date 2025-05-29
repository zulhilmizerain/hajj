import 'package:flutter/material.dart';
import 'course_detail_page.dart';
import 'ihram_guide_page.dart';
import 'wukuf_guide_page.dart';
import 'saie_guide_page.dart';
import 'tawaf_guide_page.dart';
import 'melontar_guide_page.dart';
import 'tahalul_guide_page.dart';
import 'mabit_guide_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cara_mengerjakan.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String userName = 'Pengguna';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('name') && mounted) {
        setState(() {
          userName = doc['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allTopics = [
      // ...topics,
      {
        'title': 'Cara Mengerjakan Haji',
        'image': 'assets/images/Kaabah.png',
        'type': 'guide',
        'widget': CaraMengerjakanPage(),
      },
      {
        'title': 'Panduan Ihram',
        'image': 'assets/images/Ihramm.png',
        'type': 'guide',
        'widget': IhramGuidePage(),
      },
      {
        'title': 'Panduan Wukuf',
        'image': 'assets/images/Wukuf di Arafah.jpg',
        'type': 'guide',
        'widget': WukufGuidePage(),
      },
      {
        'title': 'Panduan Sa’i',
        'image': 'assets/images/Sa’i.jpg',
        'type': 'guide',
        'widget': SaieGuidePage(),
      },
      {
        'title': 'Panduan Tawaf',
        'image': 'assets/images/Tawaf Wada’.jpg',
        'type': 'guide',
        'widget': TawafGuidePage(),
      },
      {
        'title': 'Panduan Melontar Jamrah',
        'image': 'assets/images/Melontar jumrah.jpg',
        'type': 'guide',
        'widget': MelontarGuidePage(),
      },
      {
        'title': 'Panduan Tahalul',
        'image': 'assets/images/Tahalul.png',
        'type': 'guide',
        'widget': TahalulGuidePage(),
      },
      {
        'title': 'Panduan Mabit di Mina',
        'image': 'assets/images/Mabit di Mina.jpg',
        'type': 'guide',
        'widget': MabitGuidePage(),
      },
    ];

    final filteredTopics = allTopics.where((topic) {
      final title = (topic['title'] ?? '').toString().toLowerCase();
      final content = (topic['content'] ?? '').toString().toLowerCase();
      final search = _searchQuery.toLowerCase();
      return title.contains(search) || content.contains(search);
    }).toList();

    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // ✅ dismiss when tapping outside
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Selamat datang, $userName',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/hotel');
                      },
                      icon: Icon(Icons.location_pin),
                      label: Text('Hotel'),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari topik',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...filteredTopics.map((topic) {
                      if (topic['type'] == 'guide') {
                        return _guideCard(
                          context,
                          topic['title']!,
                          topic['image']!,
                          topic['widget'] as Widget,
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(
                                  title: topic['title']!,
                                  imageUrl: topic['image']!,
                                  content: topic['content']!,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  topic['image']!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    topic['title']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _guideCard(
      BuildContext context, String title, String image, Widget page) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image,
                width: double.infinity, height: 180, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
