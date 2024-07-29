import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Firebase/Auth.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  FirebaseAuthService _authService = FirebaseAuthService();
  User? currentUser;
  int userCoins = 0;
  bool isLoading = true;
  final TextEditingController _coinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserCoins();
  }

  Future<void> _fetchUserCoins() async {
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      setState(() {
        userCoins = snapshot.data()?['rpcoins'] ?? 0;
        isLoading = false;
      });
    }
  }

  Future<void> _requestRedeem(int coins) async {
    if (coins <= userCoins && coins >= 100) {
      await FirebaseFirestore.instance.collection('redeemRequests').add({
        'userId': currentUser!.uid,
        'coins': coins,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Redeem request sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        userCoins -= coins;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
        'rpcoins': userCoins,
      });
    } else if (coins < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You need to redeem at least 100 coins',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.white,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You do not have enough coins'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem RP Coins'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.pink[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.pink[700]),
          height: MediaQuery.sizeOf(context).height,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            'Your RP Coins',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800],
                            ),
                          ),
                          subtitle: Text(
                            '$userCoins',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Redeem Coins',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[800],
                                ),
                              ),
                              TextField(
                                controller: _coinController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter coins to redeem',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.pink.shade600),
                                  ),
                                  prefixIcon: Icon(Icons.monetization_on,
                                      color: Colors.pink),
                                ),
                                cursorColor: Colors.pink,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Rupees earned',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[800],
                                ),
                              ),
                              TextField(
                                controller: _coinController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: " 0 ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.pink.shade600),
                                  ),
                                  prefixIcon: Icon(Icons.monetization_on,
                                      color: Colors.pink),
                                ),
                                cursorColor: Colors.pink,
                              ),
                              SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: () {
                                  int coinsToRedeem =
                                      int.tryParse(_coinController.text) ?? 0;
                                  _requestRedeem(coinsToRedeem);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text('Redeem Now'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (userCoins < 100)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'You need at least 100 coins to request redeem.',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
