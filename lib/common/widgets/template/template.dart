// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template_controller.dart';
import 'package:hedyety/my_theme.dart';

import '../../../Repository/auth_service.dart';

class Template extends StatelessWidget {
  Template(
      {super.key,
      required this.title,
      required this.child,
      this.actions,
      this.showDrawer = true});

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool? showDrawer;

  TemplateController controller = TemplateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: actions,
      ),
      drawer: showDrawer == true
          ? Drawer(
              child: ListView(children: [
                // DrawerHeader(
                //   decoration: BoxDecoration(color: MyTheme.primary),
                //   child: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
                //   radius: 20,),
                // ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Home',
                      style: TextStyle(color: MyTheme.primary),
                    ),
                    leading: Icon(
                      Icons.home,
                    ),
                    onTap: () {
                      controller.goToHome();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'My Events',
                      style: TextStyle(color: MyTheme.primary),
                    ),
                    leading: Icon(
                      Icons.event,
                    ),
                    onTap: () {
                      controller.goToEventsList();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'My Pledged Gifts',
                      style: TextStyle(color: MyTheme.primary),
                    ),
                    leading: Icon(
                      Icons.handshake,
                    ),
                    onTap: () {
                      controller.goToMyPledgedGifts();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Profile',
                      style: TextStyle(color: MyTheme.primary),
                    ),
                    leading: Icon(
                      Icons.person,
                    ),
                    onTap: () {
                      controller.goToProfile();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: MyTheme.primary),
                    ),
                    leading: Icon(
                      Icons.logout,
                    ),
                    onTap: () {
                      controller.signout();
                    },
                  ),
                ),
              ]),
            )
          : Drawer(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        'Sign up',
                        style: TextStyle(color: MyTheme.primary),
                      ),
                      leading: Icon(
                        Icons.app_registration,
                      ),
                      onTap: () {
                        controller.goToSignUp();
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        'Login',
                        style: TextStyle(color: MyTheme.primary),
                      ),
                      leading: Icon(
                        Icons.login,
                      ),
                      onTap: () {
                        controller.goToLogin();
                      },
                    ),
                  ),
                ],
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}
