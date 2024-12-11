import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile2_controller.dart';
import 'package:hedyety/my_theme.dart';

class Profile2 extends StatelessWidget {
  Profile2({
    super.key,
  });
  
  Profile2Controller controller = Profile2Controller();

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
               child: FutureBuilder(
                future:  controller.readEvents(),
                builder: (BuildContext, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    } 
                    else if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.events.length,
                itemBuilder: (BuildContext , int index) {
                  return Card(
                    child: ExpansionTile(
                      title: Text('Event Name: ${controller.events[index]['NAME']}'),
                      subtitle: Text('Date: ${controller.events[index]['DATE']}\n Category: ${controller.events[index]['CATEGORY']}'),
                      children: [
                        for (int i = 0; i < controller.gifts[index].length; i++)
                          ListTile(title: Text('Gift Name: ${controller.gifts[index][i]['NAME']}'),
                            subtitle: Text('Price: ${controller.gifts[index][i]['PRICE']}\n Category: ${controller.gifts[index][i]['CATEGORY']}'),
                           onTap: () {}),
                      ],
                    ),
                  );
                },
              );
               }
                   }
                  return Center(child: Text("No Events yet"));
                }),
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
