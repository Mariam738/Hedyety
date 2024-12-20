import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/Repository/models/user_model.dart';
import 'package:hedyety/features/gift_management/screens/home/home_controller.dart';
import 'package:hedyety/main_controller.dart';

class AddFriendController {
  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  LocalDatabse mydb = LocalDatabse();

  addFriend() async {
    if (key.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: const Text('Friend Added.')
      // ));
      int? res = await UserModel.addFriend(name.text, email.text, phone.text, await SharedPref().getCurrentUid());
      if(res != null)
        MainController.navigatorKey.currentState!.pushReplacementNamed('/Rhome');
    }
  }
}
