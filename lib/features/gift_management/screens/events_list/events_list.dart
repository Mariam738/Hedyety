// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/date.dart';
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
  void didChangeDependencies() {
    controller.isFriend = widget.isFriend;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isFriend) {
      controller.args = ModalRoute.of(context)?.settings.arguments;
      if (controller.args != null) {
        print("args ${controller.args}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('filter in build ${controller.myList}');
    controller.eventAnimKey = GlobalKey();

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
                      isFriend: widget.isFriend,
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
          /// Friend Events List
          widget.isFriend == true 
              ? Expanded(
                  child: StreamBuilder(
                    stream: controller.getEventStream(
                        ), // The stream to listen to
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Center(
                            child: CircularProgressIndicator(
                          color: MyTheme.primary,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error ${snapshot.error}"));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text("No data yet."));
                      }
                      {
                        Map<dynamic, dynamic> map =
                            snapshot.data?.snapshot.value as dynamic ?? {};
                        List<dynamic> list = [];
                        List<dynamic> ids = [];
                        list.clear();
                        list = map.values.toList();
                        ids = map.keys.toList();
                        for (int i = 0; i < list.length; i++) 
                          list[i]['eid'] = ids[i]; 
                        controller.myList.clear();
                        controller.myList = list;
                        if(widget.isFiltered== true){ controller.filterFriend();print('filtttttered ${controller.args}');}
                        // return Center(child: Text("$list"));

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: controller.myList.length,
                          itemBuilder: (
                            BuildContext,
                            int index,
                          ) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  // Map<dynamic, dynamic> giftsMap = controller.myList[index]['gifts'] as dynamic;
                                  // List gifts = giftsMap.keys.toList();
                                  controller.toFriendGiftList( controller.myList[index]['eid']);
                                  // controller.toGiftsList(index);
                                },
                                title: Text("${controller.myList[index]['name']}"),
                                subtitle: Text(
                                    "Category: ${controller.myList[index]['category']}\n Status: ${compareDate(controller.myList[index]['date'])}"),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              : SizedBox.shrink(),

          /// List of Events
          widget.isFriend == false 
              ? Expanded(
                  child: FutureBuilder(
                      future:  controller.readEvents(widget.isFiltered),
                      builder: (BuildContext, snapshot) {
                        print(snapshot.connectionState);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            // List events = (snapshot.data as List)
                            //     .map((e) => Map.from(e))
                            //     .toList();
                            // print('from future $events');
                            // print('from snap ${snapshot.data}');
                            print('events in before lsit ${controller.myList}');
                            List events = widget.isFiltered == false
                                ? controller.myList
                                : controller.filtered;
                            // List events = widget.isFiltered == false
                            //     ? controller.myList
                            //     : controller.filtered;
                            print('events $events  ${widget.isFiltered}');
                            return AnimatedList(
                              key: controller.eventAnimKey,
                              padding: const EdgeInsets.all(8),
                              initialItemCount: events.length,
                              itemBuilder: (BuildContext, int index, anim) {
                                return SizeTransition(
                                  key: UniqueKey(),
                                  sizeFactor: anim,
                                  child: Card(
                                    child: ListTile(
                                      onTap: () {
                                        controller.toGiftsList(index);
                                      },
                                      title: Text("${events?[index]['NAME']}"),
                                      subtitle: Text(
                                          "Category: ${events[index]['CATEGORY']}\n Status: ${compareDate(events[index]['DATE'])}"),
                                      trailing: Wrap(
                                              children: [
                                                compareDate(events[index]['DATE']) != 'Past' ? 
                                                IconButton(
                                                    icon: Icon(Icons.edit),
                                                    color:
                                                        MyTheme.editButtonColor,
                                                    onPressed: () {
                                                      controller
                                                          .toEditEventForm(
                                                              index);
                                                    }) : SizedBox.shrink(),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  color: MyTheme.primary,
                                                  onPressed: () {
                                                    controller.deleteEvent(
                                                        events[index]['ID'],
                                                        index,
                                                        "${events[index]['NAME']}",
                                                        "Category: ${events[index]['CATEGORY']}\n Status: Upcoming");
                                                    // setState(() {});
                                                  },
                                                ),
                                              ],
                                            )
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                        return Center(child: Text("No Events yet"));
                      }),
                )
              : SizedBox.shrink(),

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
