// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/my_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Profile1 extends StatefulWidget {
  const Profile1({super.key});

  @override
  State<Profile1> createState() => _TestState();
}

class _TestState extends State<Profile1> {
  bool _notification = false;

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Profile",
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// User info (Name, Email, Notification)
            const Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                radius: 50,
              ),
            ),

            Form(
              child: Column(
                children: [
                  /// Name
                  InputField(
                      initialValue: "Dumy Name",
                      readOnly: false,
                      labelText: "Name",
                      prefixIcon: const Icon(Icons.category_outlined)),
                  const SizedBox(height: 16),
                  SizedBox(height: MyTheme.sizeBtwnSections),

                  /// Email
                  InputField(
                      initialValue: "Dumy Email Value",
                      readOnly: false,
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined)),
                  SizedBox(height: MyTheme.sizeBtwnSections),

                  /// Notification Prefrence

                  MySwitch(
                    value: _notification,
                    text: "Notifications is: on. 🔔",
                    altText: "Notifications is:  off.🔕 ",
                  ),

                  SizedBox(height: MyTheme.sizeBtwnSections),

                  /// Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("🔄 Update Data🛠️"),
                    ),
                  ),
                  SizedBox(height: MyTheme.sizeBtwnSections),

                  /// My Pledged Gifts
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text("➡️ My Pledged Gift 🎁"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// https://www.dhiwise.com/post/flutter-expand-list-your-essential-guid
