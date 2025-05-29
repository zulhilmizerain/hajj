import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_page.dart';
import 'quiz_intro_page.dart';
import 'setting_page.dart';

class UserHome extends StatefulWidget {
  final int startingIndex;
  const UserHome({Key? key, this.startingIndex = 0}) : super(key: key);
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late int _currentIndex = 0;
  String userName = '';

  final List<Widget> _screens = [
    ListPage(),
    QuizIntroPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startingIndex;
    loadUserName();
  }

  Future<void> loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('name')) {
        setState(() {
          userName = doc['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Shrink to fit content
            children: [
              Image.asset('assets/images/logo2nd.png', height: 40),
              SizedBox(width: 10),
              Text('Teman Haji',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 129, 191, 160))),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: Theme.of(context).textTheme.labelMedium,
        unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Kursus'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Uji Minda'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tetapan'),
        ],
      ),
    );
  }
}
