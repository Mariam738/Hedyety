import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:hedyety/features/gift_management/models/user_model.dart';
import 'package:hedyety/main_controller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class HomeController {

  PhoneContact? contact;
  List friends = [];

  toAddFriendFrom() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/addFriendFrom');
  }

  toEventForm() {
        MainController.navigatorKey.currentState!.pushReplacementNamed('/eventForm');
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
    // Contact? contact = await _contactPicker.selectContact();
    print(contact);
  }

  getFriends() {
    friends.addAll(UserModel.getFriends());
  }
}