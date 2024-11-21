// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

class EventsList extends StatelessWidget {
  EventsList({super.key, required this.isFriend});
  final isFriend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events List"),
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
                        isEvent: true,
                      );
                    });
              },
              icon: Icon(Icons.filter_alt_outlined),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                      title: const Text("Name: The Biggest Party"),
                      subtitle:
                          const Text("Category: Birthday\n Status: Upcoming"),
                      trailing: isFriend
                          ? SizedBox(height: 0, width: 0)
                          : Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: MyTheme.editButtonColor,
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: MyTheme.primary,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),

            /// Add New Event Button
            isFriend
                ? SizedBox(width: 0, height: 0)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("➕ Add New Event 📅"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
