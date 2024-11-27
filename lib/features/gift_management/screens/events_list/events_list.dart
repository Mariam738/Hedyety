// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

import '../../../../Database/local_database.dart';

class EventsList extends StatefulWidget {
  EventsList({super.key, required this.isFriend});

  final isFriend;

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  LocalDatabse mydb = LocalDatabse();

  List myList = [];

  Future readEvents() async {
    List<Map> res =
        await mydb.readData("SELECT * FROM 'EVENTS' WHERE USERID = 1");
    myList = [];
    myList.addAll(res);
    setState(() {
      print('set state events list');
      print(myList);
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      readEvents();
      print('tyring to read events${myList}');
    } catch (e) {
      print('unable to read events ${e}');
    }
  }

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
                itemCount: myList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/giftsList', arguments: {
                          "id": myList[index]['ID'],
                          "name": myList[index]['NAME']
                        });
                      },
                      title: Text("${myList[index]['NAME']}"),
                      subtitle:
                          const Text("Category: Birthday\n Status: Upcoming"),
                      trailing: widget.isFriend
                          ? SizedBox(height: 0, width: 0)
                          : Wrap(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: MyTheme.editButtonColor,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/eventForm',
                                        arguments: {
                                          "id": myList[index]['ID'],
                                          "name": myList[index]['NAME'],
                                          "date": myList[index]['DATE'],
                                          "location": myList[index]['LOCATION'],
                                          "description": myList[index]
                                              ['DESCRIPTION'],
                                          "user": myList[index]['USERID'],
                                        });
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: MyTheme.primary,
                                  onPressed: () async {
                                    try {
                                      int res = await mydb.deleteData(
                                          "DELETE FROM EVENTS WHERE ID=${myList[index]['ID']}");
                                      readEvents();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: const Text('Delete all gifts associated with this event first.')
                                      ));
                                      print('Error deleting event ${e}');
                                    }
                                  },
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),

            /// Add New Event Button
            widget.isFriend
                ? SizedBox(width: 0, height: 0)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/eventForm');
                      },
                      child: const Text("➕ Add New Event 📅"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
