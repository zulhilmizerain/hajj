import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_quest_page.dart'; // ✅ import your add question page
import 'edit_quest_page.dart';

class AdminQuizListPage extends StatelessWidget {
  const AdminQuizListPage({Key? key}) : super(key: key);

  Future<void> deleteQuestion(String docId) async {
    await FirebaseFirestore.instance.collection('quizzes').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Senarai Soalan Kuiz')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ralat: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tiada soalan ditemui.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['question'] ?? '-'),
                  subtitle: Text("Jawapan: ${data['answer']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditQuestionPage(
                                docId: doc.id,
                                initialQuestion: data['question'],
                                initialOptions:
                                    List<String>.from(data['options']),
                                initialAnswer: data['answer'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Padam Soalan"),
                              content:
                                  Text("Anda pasti untuk padam soalan ini?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text("Batal")),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text("Padam")),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await deleteQuestion(doc.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddQuestionPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Soalan',
      ),
    );
  }
}
