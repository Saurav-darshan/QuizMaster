import 'package:flutter/material.dart';
import 'package:quiz_app/quizScreen.dart';

class Quiz {
  final String title;
  final List<Question> questions;

  Quiz({required this.title, required this.questions});
}

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final List<Quiz> quizzes = [
    Quiz(
      title: 'Coding Quiz',
      questions: [
        Question(
          questionText: 'Which language is primarily used for web development?',
          options: ['Python', 'Java', 'HTML', 'C++'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: 'What does HTML stand for?',
          options: [
            'Hyper Trainer Marking Language',
            'Hyper Text Markup Language',
            'Hyper Text Marketing Language',
            'Hyper Text Markup Leveler'
          ],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'Which of the following is a JavaScript framework?',
          options: ['Django', 'Angular', 'Flask', 'Laravel'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText:
              'What is the value of a boolean variable in programming?',
          options: ['Integer', 'String', 'True/False', 'Character'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: 'Which keyword is used to create a function in Python?',
          options: ['func', 'def', 'function', 'lambda'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'What does CSS stand for?',
          options: [
            'Cascading Style Sheets',
            'Creative Style System',
            'Computer Style Sheets',
            'Cascading System Sheets'
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          questionText:
              'Which programming language is known as the language of the web?',
          options: ['Python', 'JavaScript', 'C#', 'Java'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'Which of the following is not a relational database?',
          options: ['MySQL', 'PostgreSQL', 'MongoDB', 'SQLite'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText:
              'What is the correct syntax to print "Hello, World!" in Python?',
          options: [
            'echo "Hello, World!"',
            'print("Hello, World!")',
            'printf("Hello, World!")',
            'cout << "Hello, World!"'
          ],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'Which HTML tag is used to define an unordered list?',
          options: ['<ul>', '<ol>', '<li>', '<list>'],
          correctAnswerIndex: 0,
        ),
      ],
    ),

    Quiz(
      title: 'Science Quiz',
      questions: [
        Question(
          questionText: 'Which planet is known as the Red Planet?',
          options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'What is the chemical symbol for water?',
          options: ['O2', 'H2O', 'CO2', 'H2'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'What is the speed of light?',
          options: [
            '300,000 km/s',
            '150,000 km/s',
            '100,000 km/s',
            '50,000 km/s'
          ],
          correctAnswerIndex: 0,
        ),
        Question(
          questionText: 'Who developed the theory of relativity?',
          options: [
            'Isaac Newton',
            'Albert Einstein',
            'Niels Bohr',
            'Galileo Galilei'
          ],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'What is the largest planet in our solar system?',
          options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: 'What is the powerhouse of the cell?',
          options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Golgi apparatus'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: 'What gas do plants absorb from the atmosphere?',
          options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Helium'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: 'What is the hardest natural substance on Earth?',
          options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: 'What is the main gas found in the air we breathe?',
          options: ['Oxygen', 'Hydrogen', 'Nitrogen', 'Carbon Dioxide'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText:
              'Which organ in the human body is responsible for pumping blood?',
          options: ['Liver', 'Lungs', 'Kidney', 'Heart'],
          correctAnswerIndex: 3,
        ),
      ],
    )

    // Add more quizzes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[700],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Text(
              "Live Quizzes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.sizeOf(context).height / 1.41,
              child: ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        quizzes[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.pink,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuestionScreen(
                              questions: quizzes[index].questions,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
