import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<QuestionFormField> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionFormField());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  Future<void> _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;

      List<Map<String, dynamic>> questionsData = _questions.map((q) {
        return {
          'questionText': q.questionTextController.text,
          'options': q.optionControllers.map((c) => c.text).toList(),
          'correctAnswerIndex': int.parse(q.correctAnswerController.text) - 1,
        };
      }).toList();

      DocumentReference docRef =
          FirebaseFirestore.instance.collection('quizzes').doc(title);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          // Update existing document
          List<dynamic> existingQuestions = snapshot['questions'] ?? [];
          existingQuestions.addAll(questionsData);

          transaction.update(docRef, {
            'questions': existingQuestions,
          });
        } else {
          // Create new document
          transaction.set(docRef, {
            'title': title,
            'questions': questionsData,
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Quiz saved successfully!'),
        backgroundColor: Colors.green,
      ));

      _titleController.clear();
      setState(() {
        _questions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink[700],
        appBar: AppBar(
          title: Text(
            'Add Questions ',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.pink[700],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Quiz Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quiz title';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ..._questions.asMap().entries.map((entry) {
                    int index = entry.key;
                    QuestionFormField question = entry.value;
                    return Card(
                      elevation: 8,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            question,
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeQuestion(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Add Question'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Save Quiz'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionFormField extends StatelessWidget {
  final TextEditingController questionTextController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: questionTextController,
          decoration: InputDecoration(
            labelText: 'Enter Question Here',
            border: UnderlineInputBorder(),
            prefixIcon: Icon(Icons.question_answer),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        ...List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              controller: optionControllers[index],
              decoration: InputDecoration(
                labelText: 'Option ${index + 1}',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.radio_button_checked),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option ${index + 1}';
                }
                return null;
              },
            ),
          );
        }),
        SizedBox(height: 10),
        TextFormField(
          controller: correctAnswerController,
          decoration: InputDecoration(
            labelText: 'Correct Answer Index',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.check),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the correct answer index';
            }
            int? index = int.tryParse(value);
            if (index == null || index < 0 || index >= 4) {
              return 'Please enter a valid index (0-3)';
            }
            return null;
          },
        ),
      ],
    );
  }
}
