// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/my_theme.dart';

import '../../../../common/widgets/containers/status_container.dart';

class MyPledgeGifts extends StatelessWidget {
  const MyPledgeGifts({super.key});

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "My Pledged Gifts",
      child: Column(
        children: [
          /// List of Events
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
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
                    subtitle: const Text("Friend: Max\n Due Date: 20/12/2020"),
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
            ),
          ),
        ],
      ),
    );
  }
}
