import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Admin/Question.dart';
import 'package:quiz_app/ResultScreen.dart';


class QuestionScreen extends StatefulWidget {
  final String quizTitle;

  QuestionScreen({required this.quizTitle, required List<Question> questions});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _selectedOption = -1;
  int _correctAnswers = 0;
  late Timer _timer;
  int _start = 10;
  bool _quizStarted = false;
  int _countdownStart = 3;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startCountdown();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizTitle)
        .get();

    final quizData = snapshot.data();
    if (quizData != null) {
      final questionsData = quizData['questions'] as List;
      setState(() {
        _questions = questionsData
            .map((questionData) => Question.fromFirestore(questionData))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _submitAnswer();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownStart == 0) {
        _timer.cancel();
        setState(() {
          _quizStarted = true;
          _startTimer();
        });
      } else {
        setState(() {
          _countdownStart--;
        });
      }
    });
  }

  void _submitAnswer() {
    _timer.cancel();
    if (_selectedOption ==
        _questions[_currentQuestionIndex].correctAnswerIndex) {
      _correctAnswers++;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = -1;
        _start = 10;
        _startTimer();
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
              score: _correctAnswers,
              userId: FirebaseAuth.instance.currentUser!.uid),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: _quizStarted
          ? Padding(
              padding: const EdgeInsets.only(
                  top: 100, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _questions[_currentQuestionIndex].questionText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  ..._questions[_currentQuestionIndex]
                      .options
                      .asMap()
                      .entries
                      .map((entry) => _buildOption(entry.key, entry.value))
                      .toList(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Time left: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$_start seconds',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitAnswer,
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                'Quiz starts in $_countdownStart seconds',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildOption(int index, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: _selectedOption == index ? Colors.pink[100] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _selectedOption == index ? Colors.pink : Colors.grey[300]!,
        ),
      ),
      child: RadioListTile<int>(
        title: Text(
          text,
          style: TextStyle(
            color: _selectedOption == index ? Colors.pink : Colors.black87,
            fontWeight:
                _selectedOption == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        value: index,
        groupValue: _selectedOption,
        onChanged: (value) {
          setState(() {
            _selectedOption = value!;
          });
        },
        activeColor: Colors.pink,
      ),
    );
  }
}
