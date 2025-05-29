import 'package:flutter/material.dart';
import 'list_page.dart';
import 'admin_quiz_list.dart';
import 'setting_page.dart';
import 'istname_page.dart'; // Add this import

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ListPage(), // Kursus
    AdminQuizListPage(), // Uji Minda
    ListNamePage(), // Senarai
    SettingPage(), // Tetapan
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Kursus'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Uji Minda'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Senarai'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tetapan'),
        ],
      ),
    );
  }
}
