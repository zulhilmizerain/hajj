import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final optionControllers = List.generate(3, (_) => TextEditingController());
  String? correctAnswer;

  void saveQuestion() async {
    if (_formKey.currentState!.validate() && correctAnswer != null) {
      await FirebaseFirestore.instance.collection('quizzes').add({
        'question': questionController.text,
        'options': optionControllers.map((e) => e.text).toList(),
        'answer': correctAnswer,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soalan berjaya disimpan!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sila isi semua maklumat dan pilih jawapan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Soalan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Soalan'),
                validator: (value) => value!.isEmpty ? 'Masukkan soalan' : null,
              ),
              SizedBox(height: 12),
              ...optionControllers.asMap().entries.map(
                    (entry) => TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText:
                            'Pilihan ${String.fromCharCode(65 + entry.key)}',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Masukkan pilihan' : null,
                      onChanged: (val) {
                        setState(() {}); // Force dropdown update
                      },
                    ),
                  ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value:
                    optionControllers.map((c) => c.text).contains(correctAnswer)
                        ? correctAnswer
                        : null,
                hint: Text('Pilih jawapan yang betul'),
                items: optionControllers.map((controller) {
                  String optionText = controller.text;
                  return DropdownMenuItem<String>(
                    value: optionText,
                    child: Text(optionText.isEmpty ? '(Kosong)' : optionText),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    correctAnswer = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Sila pilih jawapan yang betul' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveQuestion,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
