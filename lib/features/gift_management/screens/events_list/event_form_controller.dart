// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/Repository/models/event_model.dart';
import 'package:hedyety/main_controller.dart';

class EventFormController {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
    TextEditingController category = TextEditingController();

  LocalDatabse mydb = LocalDatabse();

  bool isEdit = false;
  int? id;
      int? value = null;

  saveEvent() async {
    if(value== null) MainController.msngrKey.currentState!.showSnackBar(
              SnackBar(content: const Text('Remember to select a category.')));
    else if (key.currentState!.validate()) {
      key.currentState!.save();

      int? res;
      (isEdit == false)
          ? res = await EventModel.addEvent(name.text, date.text, location.text,
              description.text, category.text, await SharedPref().getCurrentUid())
          : res = await EventModel.editEvent(
              name.text, date.text, location.text, description.text , MyConstants.eventsList[value!], id!);
      print("the event value is $res");
      
      if(res != null){      
          MainController.navigatorKey.currentState!
              .pushReplacementNamed('/ReventsList');
       } else  MainController.msngrKey.currentState!.showSnackBar(
              SnackBar(content: const Text('Error. Sign up or login first')));
    }
  }
}
