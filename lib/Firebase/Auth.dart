import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signupWithEmailAndPassword(String email, String password,
      String name, String mobile, String dob) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        // Store additional user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'mobile': mobile,
          'dob': dob,
          'email': email,
          'rpcoins': 0
        });

        // Send email verification
        await user.sendEmailVerification();

        return user;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        log("Email already in use");
        Fluttertoast.showToast(msg: 'The email address is already in use.');
      } else {
        log("Error: ${e.message}");
        Fluttertoast.showToast(msg: 'An error occurred: ${e.message}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email to login.',
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'An error occurred',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return null;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
