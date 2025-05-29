import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'hotel_map_page.dart';
import 'settings_controller.dart';
import 'login_page.dart';
import 'admin_home.dart';
import 'user_home.dart';
import 'firebase_options.dart'; // If using FlutterFire CLI
import 'welcome_page.dart'; // <-- import this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = SettingsController();
  await settings.loadSettings();

  runApp(
    ChangeNotifierProvider.value(
      value: settings,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static Future<Widget> getStartPage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage();
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final role = doc.data()?['role'] ?? 'user';
    return (role == 'admin') ? AdminHome() : UserHome();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final double fontFactor = (settings.fontSize / 16.0).clamp(0.5, 2.0);

    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: fontFactor),
          child: MaterialApp(
            title: 'Teman Haji',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: WelcomePage(),
            routes: {
              '/hotel': (_) => HotelMapPage(),
            },
          ),
        );
      },
    );
  }
}
