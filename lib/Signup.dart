import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Firebase/Auth.dart';
import 'package:quiz_app/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isRemember = false;
  bool isObscure = true;
  bool _isSigningUP = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _signup() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSigningUP = true;
      });
      User? user = await _authService.signupWithEmailAndPassword(
        usernameController.text,
        passwordController.text,
        nameController.text,
        mobileController.text,
        dobController.text,
      );
      if (user != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Verify your email'),
              content: Text(
                  'A verification link has been sent to your email. Please verify your email and then login.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          _isSigningUP = false;
        });
      } else {
        setState(() {
          _isSigningUP = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(error_snack);
        usernameController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(200),
                  )),
            ),
            Align(
              alignment: Alignment(0, -.8),
              child: Image.asset(
                "assets/logo.png",
                scale: 3,
              ),
            ),
            Align(
              alignment: Alignment(0, -.35),
              child: Text(
                "Signup Here !",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.58,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Full Name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: mobileController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: 'Mobile Number',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: dobController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                hintText: 'Date of Birth',
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your date of birth';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isObscure,
                              controller: passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  child: isObscure
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                hintText: 'Password',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isObscure,
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Confirm Password',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  setState(() {
                                    _isSigningUP = false;
                                  });
                                  return 'Please confirm your password';
                                }
                                if (value != passwordController.text) {
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  setState(() {
                                    _isSigningUP = false;
                                  });
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                elevation: 10,
                                backgroundColor: Colors.pink,
                                minimumSize: const Size.fromHeight(60),
                              ),
                              onPressed: _signup,
                              child: _isSigningUP
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 243, 243, 243),
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Already have an Account? Login Now",
                                style: TextStyle(color: Colors.pink),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final error_snack = SnackBar(
  elevation: 0,
  backgroundColor: Colors.transparent,
  content: Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
    ),
    height: 30,
    child: Text(
      "Email Already used",
      style: TextStyle(color: Colors.white),
    ),
  ),
);
