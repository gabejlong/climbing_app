import "package:climbing_app/widgets/standardTextfield.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";

class sendEmailPage extends StatefulWidget {
  sendEmailPage({super.key});

  @override
  State<sendEmailPage> createState() => _sendEmailPageState();
}

class _sendEmailPageState extends State<sendEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.question,
                        size: 140,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(CupertinoIcons.chevron_back)),
                        Text('Forgot Password',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w600)),
                      ]),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'A code will be sent to your email to reset your password.',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      StandardTextfield(
                          label: 'Name',
                          hintText: 'Enter Your Email',
                          onChanged: (text) {
                            setState(() {});
                          }),
                      SizedBox(height: 30),
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
                            Navigator.pushNamed(context, '/statsPage');
                          },
                          child: Text('Send Link',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                        height: 20,
                      ),
                    ]))));
  }
}
