import 'package:flutter/material.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/Repository/models/user_model.dart';
import 'package:hedyety/main_controller.dart';

class Profile1Controller {
  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController url = TextEditingController();
  bool notification = false;
  String? uploadedImageUrl;

  // Singleton
  static final Profile1Controller _instance = Profile1Controller._internal();
  Profile1Controller._internal();
  factory Profile1Controller() {
    return _instance;
  }

  readUserProfile() async {
    var res = await UserModel.getUserById(await SharedPref().getCurrentUid());
    username.text = res[0]['NAME'];
    email.text = res[0]['EMAIL'];
    notification = res[0]['PREFERENCE'] == 1 ? true : false;
    url.text = res[0]['URL']??'';
    uploadedImageUrl = url.text;
    print('notificatino $notification');
    return res;
  }

  updateUserProfile() async {
    var res = await UserModel.updateuser(username.text, url.text,
    // email.text,
        notification == true ? 1 : 0, await SharedPref().getCurrentUid());
    // TODO update in firebase
    return true;
  }

  toMyPledgedGifts() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/RmyPledgedGifts');
  }
}
