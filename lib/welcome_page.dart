import 'package:flutter/material.dart';
import 'main.dart'; // Import to access MyApp()._getStartPage()

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _loading = false;

  void _navigateNext() async {
    setState(() => _loading = true);

    final nextPage = await MyApp.getStartPage();
    // Call your login+role logic
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 200),
            SizedBox(height: 30),
            Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _navigateNext,
                    child: Text('Mula'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // ✅ green button
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
