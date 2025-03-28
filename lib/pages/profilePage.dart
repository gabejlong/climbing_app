import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_app/widgets/nameSection.dart';
import 'package:climbing_app/widgets/notesSection.dart';
import 'package:climbing_app/widgets/friendsSection.dart';
import 'package:climbing_app/widgets/navDrawer.dart';
import 'package:climbing_app/widgets/tagsSection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:climbing_app/widgets/locationSection.dart';
import 'package:climbing_app/widgets/dateSection.dart';
import 'package:climbing_app/widgets/climbingStylesSection.dart';
import 'package:climbing_app/widgets/gradesSection.dart';
import 'package:climbing_app/widgets/attemptsSection.dart';

import 'package:climbing_app/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:climbing_app/models/lists_model.dart';
import 'package:climbing_app/models/classModels.dart';
import 'package:climbing_app/firebaseFunctions.dart';

class profilePage extends StatefulWidget {
  String userID;

  profilePage({required this.userID});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserInfo user = UserInfo(
      userID: "long.climber",
      name: "Gabriel Long",
      email: "gabrieljzlong@gmail.com",
      bio: "I LOVE to climb!",
      password: "abc",
      location: "Waterloo, ON");
  late int followers;
  late int following;
  @override
  void initState() {
    getData();

    super.initState();
  }

  void getData() async {
    user = await getUserInfo(widget.userID);
    followers = await getFollowers(widget.userID);
    following = await getFollowing(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavBottomBar(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Your Profile',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.settings_solid,
                        size: 30,
                      ))
                ],
              ),
              SizedBox(height: 15),
              Text(
                user.bio,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Following',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ]),
                  Spacer(),
                  TextButton(
                      child: Text(
                        'Find Friends',
                        style: TextStyle(
                            color: Color(0xff007BDD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {}),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
            ])));
  }
}
