// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/features/gift_management/screens/gifts/my_pledged_gifts_controller.dart';
import 'package:hedyety/my_theme.dart';

import '../../../../common/widgets/containers/status_container.dart';

class MyPledgeGifts extends StatelessWidget {
  MyPledgeGifts({super.key});

  MyPledgedGiftsController controller = MyPledgedGiftsController();

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "My Pledged Gifts",
      child: Column(
        children: [
          /// List of Pledged Gifts
          Expanded(
            child: FutureBuilder(
                future: controller.getMyPledgedGifts(),
                builder: (BuildContext, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List events = controller.mylist;

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: 10,
                        itemBuilder: (BuildContext, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/giftsList',
                                  arguments: 'The Biggest Party',
                                );
                              },
                              title: const Text("Gift Name"),
                              subtitle: const Text(
                                  "Friend: Max\n Due Date: 20/12/2020"),
                              trailing: index % 2 == 0
                                  ? StatusContainer(staus: "Recieved")
                                  : IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: MyTheme.editButtonColor,
                                      onPressed: () {},
                                    ),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return Center(child: Text("No Events yet"));
                }),
          ),
        ],
      ),
    );
  }
}
