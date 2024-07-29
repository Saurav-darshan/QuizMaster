// question.dart

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionText: data['questionText'] as String,
      options: List<String>.from(data['options'] as List),
      correctAnswerIndex: data['correctAnswerIndex'] as int,
    );
  }
}
