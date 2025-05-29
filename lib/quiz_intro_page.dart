import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      // appBar: AppBar(title: Text('Uji Minda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/Kuiz.png', height: 400),
          SizedBox(height: 20),
          Text(
            'Kuiz Haji',
            style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 12),
          Text(
            'Haji adalah salah satu daripada Rukun Islam yang lima. Haji ialah mengunjungi Baitullah al-Haram di Mekah pada bulan-bulan haji untuk mengerjakan ibadah-ibadah tertentu menurut syarat-syaratnya.',
            textAlign: TextAlign.left,
            style: theme.bodyMedium,
          ),
          SizedBox(height: 10),
          // Text(
          //   'Anda perlu menjawab sekurang-kurangnya 8 soalan dengan betul untuk lulus.',
          //   textAlign: TextAlign.center,
          //   style: theme.bodyMedium?.copyWith(color: Colors.teal),
          // ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizPage()),
              );
            },
            child: Text('Mula Kuiz'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
