import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Firebase/Auth.dart';
import 'package:quiz_app/quizScreen.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final List<Question> daily_questions = [
    Question(
      questionText: 'What is the capital of France?',
      options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Who wrote "To Kill a Mockingbird"?',
      options: ['Harper Lee', 'J.K. Rowling', 'Jane Austen', 'Mark Twain'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'What is the largest mammal in the world?',
      options: ['Elephant', 'Blue Whale', 'Giraffe', 'Great White Shark'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Which element has the chemical symbol O?',
      options: ['Osmium', 'Oxygen', 'Gold', 'Oganesson'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What is the hardest natural substance on Earth?',
      options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: 'Who painted the Mona Lisa?',
      options: [
        'Pablo Picasso',
        'Leonardo da Vinci',
        'Vincent van Gogh',
        'Claude Monet'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'What is the smallest country in the world?',
      options: ['Monaco', 'Nauru', 'San Marino', 'Vatican City'],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: 'Which is the longest river in the world?',
      options: [
        'Amazon River',
        'Nile River',
        'Yangtze River',
        'Mississippi River'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'Who developed the theory of relativity?',
      options: [
        'Isaac Newton',
        'Albert Einstein',
        'Galileo Galilei',
        'Nikola Tesla'
      ],
      correctAnswerIndex: 1,
    )
  ];
  FirebaseAuthService _authService = FirebaseAuthService();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[700],
        body: currentUser == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _authService.getUserDataStream(currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('User data not found'));
                  }

                  var userData = snapshot.data!.data()!;
                  String userName = userData['name'];
                  int userCoins = userData['rpcoins'];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Greeting Section
                        Container(
                          padding: EdgeInsets.only(
                              top: 30, left: 20, right: 20, bottom: 20),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good Morning",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    userName.isNotEmpty ? userName : "User",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    foregroundImage: AssetImage(
                                      "assets/pp2.png",
                                    ),
                                    minRadius: 50,
                                  ),
                                  Coin(userCoins: userCoins)
                                ],
                              )
                            ],
                          ),
                        ),
                        // Recent Quiz Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuestionScreen(
                                            questions: daily_questions,
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.headphones, color: Colors.pink),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "QUIZ OF THE Day  ",
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "A Basic Music Quiz",
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.yellow[200],
                                    child: Text(
                                      "10",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Featured Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.pink[600],
                                      child: Icon(Icons.person,
                                          color: Colors.white, size: 30),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "FEATURED",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Take part in challenges with friends or other players",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    "Find Friends",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Live Quizzes Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Live Quizzes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("See all",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              QuizCard(
                                title: "Statistics Math Quiz",
                                category: "Math",
                                quizCount: 12,
                              ),
                              QuizCard(
                                title: "Integers Quiz",
                                category: "Math",
                                quizCount: 10,
                              ),
                              // Add more QuizCard widgets as needed
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }));
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String category;
  final int quizCount;

  const QuizCard({
    Key? key,
    required this.title,
    required this.category,
    required this.quizCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$category • $quizCount Quizzes'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class Coin extends StatelessWidget {
  final int userCoins;

  const Coin({
    Key? key,
    required this.userCoins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 30,
        width: 70,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 242, 242),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.pink[800],
                size: 20,
              ),
            ),
            Text(
              userCoins.toString(),
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
