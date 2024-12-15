import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/main_controller.dart';

class MyPledgedGiftsController {

  List mylist = [];
    RealtimeDB fb = RealtimeDB();
      final _auth = AuthService();


  Future getMyPledgedGifts() async {
    mylist = [];
    var res = await fb.getMyPledgedGifts(await _auth.getUserId()!);
    mylist.addAll(res);
    return mylist;
  }

  Future setPurhcasedGiftStatus (String friendid, String gid) async {
    await fb.setGiftStatus(friendid, gid, 'purchased');
    MainController.navigatorKey.currentState!.pushReplacementNamed('/myPledgedGifts');
    
  }

}