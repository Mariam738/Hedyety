// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list_controller.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list_controller.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list_controller.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

import '../../../../Repository/local_database.dart';

class EventsList extends StatefulWidget {
  EventsList({super.key, required this.isFriend, this.isFiltered = false});

  final bool isFriend;
  bool? isFiltered;

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
EventsListController controller = EventsListController();

   @override
  void initState() {
    super.initState();
    // controller.readEvents();
  }

  @override
  void dispose(){
    // controller.stream.close();
    super.dispose();
  
}

  @override
  Widget build(BuildContext context) {
    print('filter in build ${controller.myList}');
    return Template(
      title: "Events List",
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FilteContainer(
                      categoryList: MyConstants.eventsList,
                      isEvent: true,
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
            child: FutureBuilder(
                future:  controller.readEvents(widget.isFiltered),
                builder: (BuildContext, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    } 
                    else if (snapshot.hasData && snapshot.data != null) {
                      // List events = (snapshot.data as List)
                      //     .map((e) => Map.from(e))
                      //     .toList();
                      // print('from future $events');
                      // print('from snap ${snapshot.data}');
                      print('events in before lsit ${controller.myList}');
                      List events = widget.isFiltered == false? controller.myList : controller.filtered;
                      print('events $events  ${widget.isFiltered}');
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: events.length,
                        itemBuilder: (BuildContext, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                controller.toGiftsList(index);
                              },
                              title:
                                  Text("${events[index]['NAME']}"),
                              subtitle: Text(
                                  "Category: ${events[index]['CATEGORY']}\n Status: Upcoming"),
                              trailing: widget.isFriend
                                  ? SizedBox(height: 0, width: 0)
                                  : Wrap(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: MyTheme.editButtonColor,
                                          onPressed: ()  {
                                            controller.toEditEventForm(index);
                                          }
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: MyTheme.primary,
                                          onPressed: () {
                                            controller.deleteEvent(
                                                events[index]['ID']);
                                            setState(() {});
                                          },
                                        ),
                                      ],
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

          /// Add New Event Button
          widget.isFriend
              ? SizedBox(width: 0, height: 0)
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.toAddEventForm();
                    },
                    child: const Text("➕ Add New Event 📅"),
                  ),
                ),
        ],
      ),
    );
  }
}
