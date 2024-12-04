import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> msngrKey = GlobalKey<ScaffoldMessengerState>();
  late bool isSignedUp;

  Future loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isSignedUp =   (pref.getString('email') !=null &&
        pref.getString(pref.getString('email')!) != null);
        print('is SignedUp $isSignedUp');
    return isSignedUp;
  }
}