import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_analysis_app/RegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:stock_analysis_app/StartScreen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 60, 16.0, 16.0),
        child:SingleChildScrollView(
          child:  Column(
            children: [
              RichText(text: TextSpan(text: "Login",style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ))

              ),
              const Image(
                  width: 400,
                  height: 200,
                  image: AssetImage(
                    'assets/images/cryptoshare.png',
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: TextField(
                    controller: password,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ))),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text
                        ).then((value) => (){
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(),
                              )
                          );
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return const AlertDialog(
                                  title: Text("Login Error"),
                                  content: Text("No user found for that email"),
                                );
                              });
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return const AlertDialog(
                                  title: Text("Login Error"),
                                  content: Text("Wrong password provided for that user."),
                                );
                              });
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    child: Text("Login"),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
                    },
                    child: Text("Don't Have an account? Register Now"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
