import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final String userId;

  ResultScreen({required this.score, required this.userId});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    _updateUserCoins();
  }

  Future<void> _updateUserCoins() async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);
    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data()!;
      final currentCoins = userData['rpcoins'] ?? 0;
      final updatedCoins = currentCoins + widget.score;

      await userRef.update({'rpcoins': updatedCoins});
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Score: ${widget.score}',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Points Earned: ${widget.score}',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => LandingScreen(),
                    //   ),
                    // );
                  },
                  child: Text('Back to Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
