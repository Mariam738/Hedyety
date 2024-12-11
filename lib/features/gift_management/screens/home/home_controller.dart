import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/features/gift_management/models/user_model.dart';
import 'package:hedyety/main_controller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter/material.dart';

class HomeController {

  PhoneContact? contact;
  List friends = [];
  TextEditingController searchEditing = TextEditingController();

  toAddFriendFrom() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/addFriendFrom');
  }

  toEventForm() {
        MainController.navigatorKey.currentState!.pushReplacementNamed('/addEventForm');
  }

  addContact() async {
    bool permission = await FlutterContactPicker.requestPermission();
    if(permission) {
      if(await FlutterContactPicker.hasPermission()) {
        contact = await FlutterContactPicker.pickPhoneContact();
        print('contact ${contact?.fullName}, ${contact?.phoneNumber?.number}');
        if(contact?.fullName != null && contact?.phoneNumber?.number !=null){
        UserModel.addContact(contact!.fullName!, contact!.phoneNumber!.number!);
        }
      }
    }
    getFriends();
  }

  Future getFriends() async {
    friends = [];
    var res = await UserModel.getFriends(await SharedPref().getCurrentUid());
    friends.addAll(res);
    print('friends searchc ${searchEditing.text}');
    if(searchEditing.text.isEmpty == false && searchEditing.text != null)
      search(searchEditing.text.toLowerCase());
    print('friends $friends');
    return friends;
  }

  search (String val) {
    friends = friends.where((e)=> e['NAME'].toString().toLowerCase().contains(val) ).toList();
    print('search $friends');
  }
  
}