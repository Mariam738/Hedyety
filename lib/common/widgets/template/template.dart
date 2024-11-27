// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/my_theme.dart';

class Template extends StatelessWidget {
  const Template(
      {super.key, required this.title, required this.child, this.actions});
  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: actions,
      ),
      drawer: Drawer(
        child: ListView(children: [
          // DrawerHeader(
          //   decoration: BoxDecoration(color: MyTheme.primary),
          //   child: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
          //   radius: 20,),
          // ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(color: MyTheme.primary),
            ),
            leading: Icon(
              Icons.home,
            ),
            onTap: () {},
          ),

          ListTile(
            title: Text(
              'My Events',
              style: TextStyle(color: MyTheme.primary),
            ),
            leading: Icon(
              Icons.event,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/eventsList');

            },
          ),
          ListTile(
            title: Text(
              'My Pledged Gifts',
              style: TextStyle(color: MyTheme.primary),
            ),
            leading: Icon(
              Icons.handshake,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Profile',
              style: TextStyle(color: MyTheme.primary),
            ),
            leading: Icon(
              Icons.person,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Log Out',
              style: TextStyle(color: MyTheme.primary),
            ),
            leading: Icon(
              Icons.logout,
            ),
            onTap: () {},
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}
