import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/main.dart';
import 'package:hedyety/main_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController email2 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  final _auth = AuthService();

  String? emailPref;
  String? passwordHashPref;

  LocalDatabse mydb = LocalDatabse();


  Future loginOffline() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // emailPref = pref.getString('email');
    passwordHashPref = pref.getString(email2.text.trim());
    // email2.text == emailPref
    //         &&
    sha512.convert(utf8.encode(password2.text)).toString() == passwordHashPref
        ? MainController.navigatorKey.currentState!.pushReplacementNamed('/home')
        : MainController.msngrKey.currentState!.showSnackBar(
            SnackBar(content: const Text('Wrong Email or Password')));
  }
  Future<int?>getCurrentUserLocalId() async {
    try {
      int res = await mydb.deleteData(
        "SELECT FROM USERS WHERE EMAIL=${email2.text.trim()}");
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('currentUser', res);
      return res;
      } catch (e) {
        return null;
      }
  }
  login() async {
    try {
      final user = _auth.loginIn(email2.text, password2.text);
      if (user != null) {
        print("loged in");
        print('user id: ${_auth.getUserId()}');
        print('user local id ${await getCurrentUserLocalId()}');
        MainController.navigatorKey.currentState!.pushReplacementNamed('/home');
      }
    } catch (e) {
      // NO internet used shared prefrence instead
      // TODO
      //loginOffline();
    }
  }
}
