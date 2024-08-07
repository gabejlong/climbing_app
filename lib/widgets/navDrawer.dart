import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:path/path.dart";

class NavDrawer extends StatelessWidget {
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
              Navigator.pushNamed(context, '/logClimbsPage');
            },
          )
        ],
      ),
    );
  }
}
