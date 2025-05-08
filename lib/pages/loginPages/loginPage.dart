import "package:climbing_app/widgets/passwordTextfield.dart";
import "package:climbing_app/widgets/standardTextfield.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:climbing_app/pages/loginPages/createAccountPage.dart";
import 'package:climbing_app/pages/loginPages/forgotPassword/sendEmailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class loginPage extends StatefulWidget {
  String? email;
  String? pwd;
  loginPage({this.email, this.pwd});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void logIn(context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email!, password: widget.pwd!);

      Navigator.pushNamed(context, '/profilePage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
            child: SizedBox.expand(
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/Log In.png"),
                            fit: BoxFit.cover)),
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(CupertinoIcons.chevron_back)),
                            Text('Welcome back!',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w500)),
                          ]),
                          StandardTextfield(
                              label: 'Username',
                              hintText: 'Enter Your Username',
                              onChanged: (text) {
                                setState(() {
                                  widget.email = text;
                                });
                              }),
                          SizedBox(height: 30),
                          PasswordTextfield(
                              label: 'Password',
                              onChanged: (text) {
                                setState(() {
                                  widget.pwd = text;
                                });
                              }),
                          SizedBox(height: 55),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.fromLTRB(30, 10, 30, 10)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 0, 0, 0))),
                              onPressed: () {
                                logIn(context);
                              },
                              child: Text('Log In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Dont have an account?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  createAccountPage(
                                                    username: '',
                                                  )));
                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.fromLTRB(30, 0, 30, 0))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => sendEmailPage()));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))
                        ])))));
  }
}
