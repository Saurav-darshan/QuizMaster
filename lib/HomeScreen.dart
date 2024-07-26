import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Firebase/Auth.dart';
import 'package:quiz_app/QuizList.dart';
import 'package:quiz_app/quizScreen.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  FirebaseAuthService _authService = FirebaseAuthService();
  User? currentUser;
  List<Question> dailyQuestions = [];
  List<Map<String, dynamic>> liveQuizzes = [];
  bool isLoadingDailyQuiz = true;
  bool isLoadingLiveQuizzes = true;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchDailyQuiz();
    _fetchLiveQuizzes();
  }

  Future<void> _fetchDailyQuiz() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc('Daily Quiz')
          .get();
      if (snapshot.exists) {
        List<Question> questions =
            (snapshot.data() as Map<String, dynamic>)['questions']
                .map<Question>((data) => Question.fromFirestore(data))
                .toList();
        setState(() {
          dailyQuestions = questions;
          isLoadingDailyQuiz = false;
        });
      } else {
        setState(() {
          isLoadingDailyQuiz = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingDailyQuiz = false;
      });
    }
  }

  Future<void> _fetchLiveQuizzes() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();
      List<Map<String, dynamic>> quizzes = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'title': data['title'] ?? 'No Title',
          'category': data['category'] ?? 'No Category',
          'quizCount': data['quizCount'] ?? 0,
        };
      }).toList();
      setState(() {
        liveQuizzes = quizzes;
        isLoadingLiveQuizzes = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLiveQuizzes = false;
      });
    }
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
                              // if (dailyQuestions.isNotEmpty) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => QuestionScreen(
                              //                 quizTitle: 'Daily Quiz',
                              //                 questions: ,
                              //               )));
                              //   // }
                              // }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.query_builder_sharp,
                                      color: Colors.pink),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "QUIZ OF THE DAY",
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          dailyQuestions.isNotEmpty
                                              ? "A Basic Music Quiz"
                                              : "Quiz is not ready yet, try after some time",
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuizListScreen()));
                                },
                                child: Text("See all",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        isLoadingLiveQuizzes
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: liveQuizzes.map((quiz) {
                                    return QuizCard(
                                      title: quiz['title'],
                                      quizCount: quiz['quizCount'],
                                    );
                                  }).toList(),
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

  final int quizCount;

  const QuizCard({
    Key? key,
    required this.title,
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
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionScreen(
                quizTitle: title,
                questions: [],
              ),
            ),
          );
        },
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
      questionText: data['questionText'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
    );
  }
}
