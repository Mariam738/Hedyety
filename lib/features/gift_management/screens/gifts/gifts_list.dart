// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/status_container.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

class GiftsList extends StatelessWidget {
  GiftsList({super.key, required this.isFriend});

  final bool isFriend;
  @override
  Widget build(BuildContext context) {
    return Template(
      title: "The Biggest Party's Gifts List",
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FilteContainer(
                      categoryList: MyConstants.categoryList,
                      isEvent: false,
                    );
                  });
            },
            icon: Icon(Icons.filter_alt_outlined),
          ),
        )
      ],
      child: Column(
        children: [
          /// List of Events
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  // color: index % 2 ==0 ?Colors.amber : null,
                  child: ListTile(
                    onTap: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   '/giftsList',
                      //   arguments: 'args',
                      // );
                    },
                    title: Text("Name: The Biggest Party"),
                    subtitle: Text("Category: Birthday\n Status: Upcoming"),
                    trailing: Wrap(
                      children: [
                        index % 2 == 0
                            ? isFriend
                                ? IconButton(
                                    icon: Icon(Icons.handshake,
                                        color: Colors.amber),
                                    tooltip: 'Pledge',
                                    onPressed: () {})
                                : Wrap(children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: MyTheme.editButtonColor,
                                      onPressed: () {},
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: MyTheme.primary,
                                      onPressed: () {},
                                    ),
                                    // SizedBox(width: 10),
                                  ])
                            : StatusContainer(staus: "Pledged"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// Add New Gift Button
          isFriend
              ? SizedBox.shrink()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("➕ Add New Gift 🎁"),
                  ),
                ),
        ],
      ),
    );
  }
}
