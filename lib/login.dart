import 'package:flutter/material.dart';
import 'package:quiz_app/LandingScreen.dart';
import 'package:quiz_app/Signup.dart';
import 'package:quiz_app/forgetPassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRemember = false;
  bool isObscure = true;

  bool isUserNotEmpty = false;
  bool isPasswordNotEmpty = false;
  int status = 0;
  bool _isSigning = false;
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
                  )),
            ),
            Align(
                alignment: Alignment(0, -.5),
                child: Image.asset(
                  "assets/logo.png",
                  scale: 3,
                )),
            Align(
                alignment: Alignment(0, -.1),
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 25),
                )),
            Align(
                alignment: Alignment(0, 1),
                child: Container(
                  height: MediaQuery.sizeOf(context).height / 1.9,
                  child: Card(
                    //color: Color.fromARGB(255, 148, 203, 241),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Form(
                        key: formKey,
                        child: Column(children: [
                          TextFormField(
                            validator: (value) {
                              value = status.toString();
                            },
                            controller: UsernameController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_3),
                                hintText: 'Email'),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            validator: (value) {
                              value = status.toString();
                            },
                            obscureText: isObscure,
                            controller: PasswordController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_rounded),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (isObscure == true) {
                                      setState(() {
                                        isObscure = false;
                                      });
                                    } else {
                                      setState(() {
                                        isObscure = true;
                                      });
                                    }
                                  },
                                  child: isObscure == false
                                      ? Icon(Icons.visibility_off_rounded)
                                      : Icon(Icons.visibility_rounded),
                                ),
                                hintText: 'Password'),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Checkbox(
                                    value: isRemember,
                                    onChanged: (value) {
                                      setState(() {
                                        isRemember = value!;
                                      });
                                    }),
                                Text(
                                  "Remember Me",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ]),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text(
                                  "Forgot password ?",
                                  style: const TextStyle(color: Colors.pink),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Colors.pink,
                              shape: StadiumBorder(),
                              elevation: 20,
                              //shadowColor: myColor,
                              backgroundColor: Colors.pink,
                              minimumSize: const Size.fromHeight(60),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LandingScreen()));
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 20),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Text(
                                "Don't have a Account? SignUp Now",
                                style: TextStyle(color: Colors.pink),
                              ))
                        ]),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
