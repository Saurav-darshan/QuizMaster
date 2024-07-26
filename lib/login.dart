import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/LandingScreen.dart';
import 'package:quiz_app/Signup.dart';
import 'package:quiz_app/forgetPassword.dart';
import 'package:quiz_app/Firebase/Auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRemember = false;
  bool isObscure = true;
  bool _isSigning = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isSigning = true;
      });

      User? user = await _authService.signInWithEmailAndPassword(
        usernameController.text,
        passwordController.text,
      );

      setState(() {
        _isSigning = false;
      });

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed. Please check your credentials and verify your email.'),
        ));
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
              height: MediaQuery.sizeOf(context).height / 3,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(200),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -.5),
              child: Image.asset(
                "assets/logo.png",
                scale: 3,
              ),
            ),
            Align(
              alignment: Alignment(0, -.1),
              child: Text(
                "Login",
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
                height: MediaQuery.sizeOf(context).height / 1.9,
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
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_3),
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            obscureText: isObscure,
                            controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password_rounded),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                child: isObscure
                                    ? Icon(Icons.visibility_rounded)
                                    : Icon(Icons.visibility_off_rounded),
                              ),
                              hintText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isRemember,
                                    onChanged: (value) {
                                      setState(() {
                                        isRemember = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Remember Me",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Colors.pink,
                              shape: StadiumBorder(),
                              elevation: 20,
                              backgroundColor: Colors.pink,
                              minimumSize: const Size.fromHeight(60),
                            ),
                            onPressed: _isSigning ? null : _login,
                            child: _isSigning
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Don't have an Account? Sign Up Now",
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
          ],
        ),
      ),
    );
  }
}
