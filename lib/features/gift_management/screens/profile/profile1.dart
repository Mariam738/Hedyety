// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1_controller.dart';
import 'package:hedyety/my_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Profile1 extends StatefulWidget {
  const Profile1({super.key});

  @override
  State<Profile1> createState() => _TestState();
}

class _TestState extends State<Profile1> {
  Profile1Controller controller = Profile1Controller();

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Profile",
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: controller.readUserProfile(),
            builder: (BuildContext, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: MyTheme.primary,
                ));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error"));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Column(
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
                        key: controller.key,
                        child: Column(
                          children: [
                            /// Name
                            InputField(
                              readOnly: false,
                              labelText: "Username",
                              prefixIcon: const Icon(Icons.person),
                              controller: controller.username,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(height: MyTheme.sizeBtwnSections),

                            /// Email
                            // InputField(
                            //   readOnly: false,
                            //   labelText: "Email",
                            //   prefixIcon: const Icon(Icons.email_outlined),
                            //   controller: controller.email,
                            // ),
                            // SizedBox(height: MyTheme.sizeBtwnSections),

                            /// Notification Prefrence

                            MySwitch(
                              value: controller.notification,
                              text: "Notifications is: on. 🔔",
                              altText: "Notifications is:  off.🔕 ",
                            ),

                            SizedBox(height: MyTheme.sizeBtwnSections),

                            /// Update Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.updateUserProfile();
                                  setState(() {});
                                },
                                child: const Text("🔄 Update Data🛠️"),
                              ),
                            ),
                            SizedBox(height: MyTheme.sizeBtwnSections),

                            /// My Pledged Gifts
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.toMyPledgedGifts();
                                },
                                child: const Text("➡️ My Pledged Gift 🎁"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
              return Center(child: Text("No Events yet"));
            }),
      ),
    );
  }
}
// https://www.dhiwise.com/post/flutter-expand-list-your-essential-guid
