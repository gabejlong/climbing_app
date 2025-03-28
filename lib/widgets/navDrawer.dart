import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";

/*class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.home),
            title: Text('Home'),
            onTap: () {
              if (route != null && route.settings.name == '/homePage') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/homePage');
              }
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.list_bullet),
            title: Text('List'),
            onTap: () {
              if (route != null && route.settings.name == '/listClimbsPage') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/listClimbsPage');
              }
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.doc),
            title: Text('Log Climbs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/newSessionPage');
            },
          )
        ],
      ),
    );
  }
}*/

class NavBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffAEADB2),
              width: 0.3,
            ),
          ),
        ),
        child: BottomAppBar(
          padding: EdgeInsets.all(0),
          color: Colors.white,
          height: 50,
          elevation: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/listClimbsPage');
                  },
                  icon: Icon(
                    CupertinoIcons.list_bullet,
                    color: Colors.black,
                    size: 25,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/statsPage');
                  },
                  icon: Icon(
                    CupertinoIcons.waveform_path_ecg,
                    color: Colors.black,
                    size: 23,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/newSessionPage');
                  },
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: Colors.blue,
                    size: 50,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/activityPage');
                  },
                  icon: Icon(
                    CupertinoIcons.person_2_fill,
                    color: Colors.black,
                    size: 23,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profilePage');
                  },
                  icon: Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.black,
                    size: 23,
                  )),
            ],
          ),
        ));
  }
}
