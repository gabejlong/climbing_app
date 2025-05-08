import "package:climbing_app/database/firebaseUsers.dart";
import "package:climbing_app/pages/listClimbsPage.dart";
import "package:climbing_app/widgets/standardTextfield.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import 'package:climbing_app/models/allModels.dart';

class accountSetUpPage extends StatefulWidget {
  String? displayName;
  String? location;
  String? bio;

  accountSetUpPage({this.displayName, this.location, this.bio});

  @override
  State<accountSetUpPage> createState() => _accountSetUpPageState();
}

class _accountSetUpPageState extends State<accountSetUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void setUpAccount() async {
    // get uID

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserItem userItem = UserItem(
          userID: user.uid,
          username: user.displayName!,
          name: widget.displayName!,
          email: user.email!,
          bio: widget.bio!,
          location: widget.location!);
      addUser(userItem);
    }
    // save user info to firestore
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
                            Text('Account Set-Up',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                          ]),
                          SizedBox(height: 25),
                          StandardTextfield(
                              label: 'Name',
                              hintText: 'Enter Your Name',
                              onChanged: (text) {
                                setState(() {
                                  widget.displayName = text;
                                });
                              }),
                          SizedBox(height: 30),
                          StandardTextfield(
                              label: 'Location',
                              suffixIcon: Icon(CupertinoIcons.search),
                              hintText: 'Enter Your City',
                              onChanged: (text) {
                                setState(() {
                                  widget.location = text;
                                });
                              }),
                          SizedBox(height: 30),
                          StandardTextfield(
                              label: 'Account Bio',
                              hintText: 'I Love to Climb',
                              onChanged: (text) {
                                setState(() {
                                  widget.bio = text;
                                });
                              }),
                          SizedBox(height: 30),
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
                                setUpAccount();
                                Navigator.pushNamed(context, '/profilePage');
                              },
                              child: Text('Finish Set-Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 20,
                          ),
                        ])))));
  }
}
