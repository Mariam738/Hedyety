import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/features/authentication/screens/sign_up.dart';
import 'package:hedyety/Repository/models/user_model.dart';
import 'package:hedyety/main.dart';
import 'package:hedyety/main_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // important

class SignupController{
  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  final _auth = AuthService();

  LocalDatabse mydb = LocalDatabse();

  RealtimeDB fb = RealtimeDB();

  saveDataLocal(Digest digest, String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString('username', username.text);
    pref.setString('email', email.text);
    pref.setString(email.text.trim(), digest.toString());
    print('email: ${pref.get('email')}');
    print('pass: ${pref.get(pref.getString('email')!)}');

    try {
      int pref = 1;
      var res = await UserModel.addUser(username.text.trim(), email.text.trim(), phone.text.trim(), uid);
      // await mydb.insertData(
      //     '''INSERT INTO 'USERS' ('NAME','EMAIL', 'PHONE', 'UID', 'PREFERENCE') VALUES ("${username.text.trim()}","${email.text.trim()}","${phone.text.trim()}","${uid}","$pref")''');
      print("the value is $res");
    } catch (e) {
      print("Error adding user :(" + e.toString());
    }
  }

  saveDataCloud(Map<String, dynamic> usr, String uid) async {
    fb.addUser(usr, uid);
    fb.addPhoneUser(phone.text.trim(), uid);
  }

  signup() async {
    if (key.currentState!.validate()) {
      // Form is valid
      final user = await _auth.signUp(email.text, password.text);
      if (user != null) {
        print("successfult sign up");
        Digest digest = sha512.convert(utf8.encode(password.text));
        saveDataLocal(digest, _auth.getUserId()!);
        UserModel usr = UserModel(name: username.text.trim(), email: email.text.trim(), phone: phone.text, password: password.text.trim(), prefrence: true);
        saveDataCloud(usr.toJson(), _auth.getUserId()!);
        await FirebaseMessaging.instance.subscribeToTopic(await _auth.getUserId()!);
        MainController.navigatorKey.currentState!.pushReplacementNamed('/Llogin');
        // navigatorKey.of(context).pushReplacementNamed(context, '/login');
      }
      else 
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(content: Text("This account already exist. Try logging in")));
    }
  }


}
