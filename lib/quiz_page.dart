import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_home.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  bool isAnswered = false;
  bool isCorrect = false;
  int score = 0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> loadQuestions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('quizzes').get();

    final loadedQuestions = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'question': data['question'],
        'options': List<String>.from(data['options']),
        'answer': data['answer'],
      };
    }).toList();

    setState(() {
      questions = loadedQuestions;
    });
  }

  void checkAnswer(String selected) {
    final correctAnswer = questions[currentIndex]['answer'];
    setState(() {
      isAnswered = true;
      isCorrect = selected == correctAnswer;
      if (isCorrect) score += 1;
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        isCorrect = false;
      });
    } else {
      saveScoreAndFinish();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex;
        isAnswered = false;
        isCorrect = false;
      });
    }
  }

  Future<void> saveScoreAndFinish() async {
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    final userName = userDoc.data()?['name'] ?? 'Unnamed';

    await FirebaseFirestore.instance.collection('scores').add({
      'uid': currentUser!.uid,
      'name': userName,
      'score': score,
      'total': questions.length,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FinishScreen(score: score, total: questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Uji Minda")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => UserHome(startingIndex: 1)),
              (route) => false,
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo2nd.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Teman Haji',
              style: TextStyle(color: const Color.fromARGB(255, 129, 191, 160)),
            ),
          ],
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isAnswered
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 100,
                      ),
                      Text(
                        isCorrect ? 'Betul!' : 'Salah!',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: nextQuestion,
                        icon: Icon(Icons.arrow_forward),
                        label: Text('Seterusnya'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          current['question'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 20),
                      ...List.generate(
                        current['options'].length,
                        (index) {
                          final opt = current['options'][index];
                          final label =
                              String.fromCharCode(65 + index); // A, B, C, ...

                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              onPressed: () => checkAnswer(opt),
                              child: Text(
                                '$label. $opt',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )),
    );
  }
}

class FinishScreen extends StatelessWidget {
  final int score;
  final int total;

  const FinishScreen({Key? key, required this.score, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        automaticallyImplyLeading: false, // 👈 removes the back arrow
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo2nd.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Teman Haji',
              style: TextStyle(color: const Color.fromARGB(255, 129, 191, 160)),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Tahniah.png',
              fit: BoxFit.cover, // 🔁 Stretches image to cover the whole area
              // width: double.infinity, // ⬅ Full width
              // height: double.infinity, // ⬆ Full height
            ),
            SizedBox(height: 12),
            Text(
              "Skor anda: $score / $total",
              style: TextStyle(fontSize: 20, color: Colors.teal),
            ),
            SizedBox(height: 10),
            Text("Selamat menunaikan ibadah Haji"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => UserHome()),
                  (route) => false,
                );
              },
              child: Text('Selesai'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
