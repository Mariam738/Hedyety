import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/features/gift_management/models/user_model.dart';
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
  Future setCurrentUserLocalId() async {
    try {
      var res = await UserModel.getUserByEmail(email2.text.trim());
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('currentUser',  res[0]['ID']);
      return res;
      } catch (e) {
        print('error setCurrentUserLocalId $e');
        return null;
      }
  }
  login() async {
    try {
      final user = await _auth.loginIn(email2.text, password2.text);
      print('login $user');
      if (user != null) {
        print("loged in");
        print('user id: ${_auth.getUserId()}');
        print('user local id ${await setCurrentUserLocalId()}');
        MainController.navigatorKey.currentState!.pushReplacementNamed('/home');
      } 
      else {
        MainController.msngrKey.currentState!.showSnackBar(SnackBar(content: Text('Wrong Email or Password')));
      }
    } catch (e) {
      // NO internet used shared 
      //prefrence instead
      // TODO
      //loginOffline();
    }
  }
}
