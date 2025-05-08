import "package:climbing_app/widgets/passwordTextfield.dart";
import "package:climbing_app/widgets/standardTextfield.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:climbing_app/pages/loginPages/accountSetUpPage.dart";
import 'package:firebase_auth/firebase_auth.dart';

class createAccountPage extends StatefulWidget {
  String? username;
  String? pwd;
  String? confirmPwd;
  String? email;
  createAccountPage({this.username, this.pwd, this.confirmPwd, this.email});

  @override
  State<createAccountPage> createState() => _createAccountPageState();
}

class _createAccountPageState extends State<createAccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void signUp(context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email!, password: widget.pwd!);
      User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(widget.username);
      }
      Navigator.pushNamed(context, '/accountSetUpPage');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        print('That password is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for that email.');
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
                            image: AssetImage("assets/images/Sign Up.png"),
                            fit: BoxFit.cover)),
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
                            Text('Create Account',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                          StandardTextfield(
                              label: 'Create Username',
                              hintText: 'Enter Your Username',
                              onChanged: (text) {
                                setState(() {
                                  widget.username = text;
                                });
                              }),
                          SizedBox(height: 26),
                          StandardTextfield(
                              label: 'Email',
                              hintText: 'Enter Your Email',
                              onChanged: (text) {
                                setState(() {
                                  widget.email = text;
                                });
                              }),
                          SizedBox(height: 26),
                          PasswordTextfield(
                              label: 'Password',
                              onChanged: (text) {
                                setState(() {
                                  widget.pwd = text;
                                });
                              }),
                          SizedBox(height: 26),
                          PasswordTextfield(
                              label: 'Confirm Password',
                              onChanged: (text) {
                                setState(() {
                                  widget.confirmPwd = text;
                                });
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.fromLTRB(30, 12, 30, 12)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 0, 0, 0))),
                              onPressed: () {
                                signUp(context);
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/loginPage');
                                    },
                                    child: Text(
                                      'Log in',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]),
                        ])))));
  }
}
