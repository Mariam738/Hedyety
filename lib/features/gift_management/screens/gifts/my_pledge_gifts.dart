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

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.mylist.length,
                        itemBuilder: (BuildContext, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   '/giftsList',
                                //   arguments: 'The Biggest Party',
                                // );
                              },
                              title: Text("Gift Name: ${controller.mylist[index]['giftName']}"),
                              subtitle: Text(
                                  "Friend: ${controller.mylist[index]['firendName']}\n Due Date: ${controller.mylist[index]['eventDate']}"),
                              trailing: 
                              Wrap(
                                children: [
                                    StatusContainer(staus: controller.mylist[index]['giftStatus']),
                                      (controller.mylist[index]['giftStatus']).toLowerCase() == 'pledged' ?
                                  IconButton(
                                      icon: const Icon(Icons.check_circle),
                                      color: MyTheme.editButtonColor,
                                      onPressed: () {
                                        controller.setPurhcasedGiftStatus(controller.mylist[index]['fid'], controller.mylist[index]['eid'],controller.mylist[index]['giftName'], controller.mylist[index]['gid']);
                                      },
                                     )
                                  : SizedBox.shrink()
                                ],
                              )
                             
                            ),
                          );
                        },
                      );
                    }
                  }
                  return Center(child: Text("No pledged gifts yet"));
                }),
          ),
        ],
      ),
    );
  }
}
