import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuestionPage extends StatefulWidget {
  final String docId;
  final String initialQuestion;
  final List<String> initialOptions;
  final String initialAnswer;

  const EditQuestionPage({
    required this.docId,
    required this.initialQuestion,
    required this.initialOptions,
    required this.initialAnswer,
  });

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController questionController;
  late List<TextEditingController> optionControllers;
  String? correctAnswer;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.initialQuestion);
    optionControllers = widget.initialOptions
        .map((opt) => TextEditingController(text: opt))
        .toList();
    correctAnswer = widget.initialAnswer;
  }

  Future<void> updateQuestion() async {
    if (_formKey.currentState!.validate() && correctAnswer != null) {
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.docId)
          .update({
        'question': questionController.text,
        'options': optionControllers.map((e) => e.text).toList(),
        'answer': correctAnswer,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soalan berjaya dikemaskini!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Soalan')),
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
                      onChanged: (val) => setState(() {}),
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
                onChanged: (value) => setState(() => correctAnswer = value),
                validator: (value) =>
                    value == null ? 'Sila pilih jawapan yang betul' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateQuestion,
                child: Text('Kemaskini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
