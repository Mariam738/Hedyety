import 'dart:async';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/common/custom_page_routes.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/date.dart';
import 'package:hedyety/Repository/models/event_model.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gifts_list.dart';
import 'package:hedyety/main_controller.dart';
import 'dart:collection';

import 'package:hedyety/my_theme.dart';

class EventsListController {
  static final EventsListController _instance =
      EventsListController._internal();
  LocalDatabse mydb = LocalDatabse();
  List myList = [];
  List filtered = [];

  var args;
  RealtimeDB fb = RealtimeDB();
  bool? isFriend;
  GlobalKey<AnimatedListState> eventAnimKey = GlobalKey();

  EventsListController._internal();

  factory EventsListController() {
    return _instance;
  }

  void removeItem(int ind, String title, String subtitle) {
    eventAnimKey.currentState!.removeItem(ind, (_, anim) {
      return SizeTransition(
        sizeFactor: anim,
        child: Card(
          color: Colors.red.shade900,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));
    myList.removeAt(ind);
  }

  Future readEvents(isFiltered) async {
    print('readEvents  here $isFiltered');
    if (isFiltered) return List<Map>;
    myList.clear();
    print('readEvents after clearing $myList');

    List<Map> res =
        await EventModel.getEvents(await SharedPref().getCurrentUid());

    myList.addAll(res);

    print('readEvents $myList');
    return myList;
  }

  deleteEvent(int id, int ind, String title, String subtitle) async {
    var res = await EventModel.deleteEvent(id);
    res != null
        ? removeItem(ind, title, subtitle)
        : MainController.msngrKey.currentState!.showSnackBar(SnackBar(
            content: const Text(
                'Delete all gifts associated with this event first.')));
  }

  toFriendGiftList(String eid) {
    MainController.navigatorKey.currentState!.pushReplacementNamed(
        '/LfriendGiftsList',
        arguments: {'uid': args['uid'], 'eid': eid});
    // print(
    //     'args > gifts $args ${myList[index]['GIFTS']} ${myList[index]['ID']}');
  }

  toGiftsList(int index) {
    if (isFriend!) {
      //  MainController.navigatorKey.currentState!.pushReplacement(CustomPageRoutes(
      //   child:  GiftsList(isFriend: false, isFiltered: true,), dir: AxisDirection.left));

      MainController.navigatorKey.currentState!
          .pushReplacementNamed('/LfriendGiftsList', arguments: {
        'UID': args,
        'GIFTS': myList[index]['GIFTS'],
        'EID': myList[index]['ID']
      });
      print(
          'args > gifts $args ${myList[index]['GIFTS']} ${myList[index]['ID']}');
    } else {
      MainController.navigatorKey.currentState!
          .pushReplacementNamed('/LgiftsList', arguments: {
        "id": myList[index]['ID'],
        "name": myList[index]['NAME']
      });
      print('hhhhh ${myList[index]['ID']} ${myList[index]['NAME']}}');
    }
  }

  toEditEventForm(int index) {
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/LeditEventForm', arguments: {
      "id": myList[index]['ID'],
      "name": myList[index]['NAME'],
      "date": myList[index]['DATE'],
      "location": myList[index]['LOCATION'],
      "description": myList[index]['DESCRIPTION'],
      "category": myList[index]['CATEGORY'],
      "user": myList[index]['USERID'],
    });
  }

  toAddEventForm() async {
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/LaddEventForm');
  }

  filter(bool isAscending, List category, List status) async {
    if (category.isEmpty) category = MyConstants.eventsList;
    if (status.isEmpty) status = MyConstants.eventStatusList;
    myList = await readEvents(false);
    print('myList $myList');

    isAscending
        ? myList.sort((a, b) {
            return a['NAME'].compareTo(b['NAME']);
          })
        : myList.sort((a, b) {
            return b['NAME'].compareTo(a['NAME']);
          });

    filtered = myList.where((e) => category.contains(e['CATEGORY'])).toList();
    filtered =
        filtered.where((e) => status.contains(compareDate(e['DATE']))).toList();

    MainController.navigatorKey.currentState!.pop();
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/LfilteredEventsList', arguments: args);
    return filtered;
  }

  Future readFriendEvents() async {
    Map res = await fb.getEventsByUid(args['uid']);
    Map<String, dynamic> casted = Map<String, dynamic>.from(res);
    List<Map> list = casted.entries.map((entry) {
      String id = entry.key as String;
      Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
      return {
        "ID": id,
        "DATE": data["date"],
        "NAME": data["name"],
        "LOCATION": data["location"],
        "CATEGORY": data["category"],
        "GIFTS": data["gifts"] != null ? data["gifts"].keys.toList() : [],
      };
    }).toList();
    myList = [];
    myList.addAll(list);
    return myList;
  }

  filterForFriend(bool isAscending, List category, List status) async {
    MainController.navigatorKey.currentState!.pop();
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/LfriendFilteredEventsList', arguments: {
      'uid': args['uid'],
      'isAscending': isAscending,
      'category': category,
      'status': status
    });
    return;
  }

  filterFriend() {
    bool isAscending = args['isAscending'];
    List category = args['category'];
    List status = args['status'];
    if (category.isEmpty) category = MyConstants.eventsList;
    if (status.isEmpty) status = MyConstants.eventStatusList;
    isAscending
        ? myList.sort((a, b) {
            return a['name'].compareTo(b['name']);
          })
        : myList.sort((a, b) {
            return b['name'].compareTo(a['name']);
          });

    filtered = myList.where((e) => category.contains(e['category'])).toList();
    filtered =
        filtered.where((e) => status.contains(compareDate(e['date']))).toList();
    myList = filtered;
    return;
  }

  getEventStream() {
    return fb.getEventStream(args['uid']);
  }
}
