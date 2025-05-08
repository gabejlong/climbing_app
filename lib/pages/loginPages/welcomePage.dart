import "package:climbing_app/widgets/standardTextfield.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";
import 'package:climbing_app/pages/loginPages/createAccountPage.dart';
import 'package:climbing_app/pages/loginPages/loginPage.dart';

class welcomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                            image: AssetImage("assets/images/Start Page.png"),
                            fit: BoxFit.cover)),
                    padding: EdgeInsets.fromLTRB(20, 160, 20, 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Welcome to',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'DEFY',
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 10),
                          ),
                          SizedBox(
                            height: 80,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => createAccountPage(
                                      username: '',
                                    ),
                                  ),
                                );
                              },
                              child: Text('Get Started',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 20,
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.fromLTRB(56, 12, 56, 12)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100))),
                                overlayColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 212, 212, 212))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => loginPage(),
                                ),
                              );
                            },
                            child: Text('Log In',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          )
                        ])))));
  }
}
