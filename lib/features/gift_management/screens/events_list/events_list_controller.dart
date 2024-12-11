import 'dart:async';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/models/event_model.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list.dart';
import 'package:hedyety/main_controller.dart';
import 'dart:collection';

class EventsListController {
  static final EventsListController _instance = EventsListController._internal();
  LocalDatabse mydb = LocalDatabse();
  List myList = [];
  List filtered = [];

  EventsListController._internal();

  factory EventsListController() {
    return _instance;
  }


  Future readEvents(isFiltered) async {
    print('readEvents  here $isFiltered');
    if(isFiltered) return List<Map>;
    myList.clear();
        print('readEvents after clearing $myList');

    List<Map> res =
        await EventModel.getEvents(await SharedPref().getCurrentUid());

    myList.addAll(res);

    print('readEvents $myList');
    return myList;
  }

  deleteEvent(int id) async {
    var res = await EventModel.deleteEvent(id);
    res != null
        ? readEvents(false)
        : MainController.msngrKey.currentState!.showSnackBar(SnackBar(
            content: const Text(
                'Delete all gifts associated with this event first.')));
  }

  toGiftsList(int index) {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/giftsList',
        arguments: {"id": myList[index]['ID'], "name": myList[index]['NAME']});
  }

  toEditEventForm(int index) {
    MainController.navigatorKey.currentState!
        .pushReplacementNamed('/editEventForm', arguments: {
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
        .pushReplacementNamed('/addEventForm');
  }

  filter(bool isAscending, List category, List status) async {
    if(category. isEmpty) category = MyConstants.eventsList;
    if(status. isEmpty) status = MyConstants.eventStatusList;
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
      MainController.navigatorKey.currentState!.pop();
      MainController.navigatorKey.currentState!.pushReplacementNamed('/filteredEventsList');
      return filtered;
  }
}
