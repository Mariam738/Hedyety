import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';
import 'package:hedyety/my_theme.dart';

class Profile2 extends StatelessWidget {
  const Profile2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events and Gifts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            /// List of Events and Assoicated Gifts
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ExpansionTile(
                      title: Text('Event Name $index'),
                      children: [
                        for (int i = 0; i < 3; i++)
                          ListTile(title: Text('Gift $i'), onTap: () {}),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// Publish button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("⬆️ Publish 📢"),
              ),
            ),
            SizedBox(height: MyTheme.sizeBtwnSections),
          ],
        ),
      ),
    );
  }
}
