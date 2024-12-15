import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/features/gift_management/models/event_model.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';
import 'package:hedyety/main_controller.dart';

class Profile2Controller {
  List events = [];
  List gifts = [];
  RealtimeDB fb = RealtimeDB();
  final _auth = AuthService();


  Future readEvents() async {
    events.clear();
    List<Map> res =
        await EventModel.getEvents(await SharedPref().getCurrentUid());
    events.addAll(res);
    print('readEvents $events');
    gifts.clear();
    for (int i = 0; i < events.length; i++) {
      await readGifts(events[i]['ID']);
    }
    return events;
  }

  Future readGifts(id) async {
    List<Map> res = await GiftModel.getGifts(id);
    gifts.add(res);
    print('readGifts $gifts');
    return gifts;
  }

  Future<void> publishEvents() async {
    print('publishEvents $events');
    List<EventModel> list = events.map((e)=>EventModel(id: e['ID'],name: e['NAME'], date: e['DATE'], location: e['LOCATION'], category:e['CATEGORY'], eid: e['EID'])).toList();
    bool res = await fb.publishUserEvents(list, mapGifts(), _auth.getUserId()!);
    res == true ?
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(content: Text('Events Published Successfully'))) :
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(content: Text('Error publishing events. Please try again later'))) ;
    
  }
  List mapGifts() {
    return gifts.map((subList)=> subList.map((e)=> GiftModel(id: e['ID'], name: e['NAME'], description: e['DESCRIPTION'], category: e['CATEGORY'], status: e['STATUS'], price: e['PRICE'],  gid: e['GID'])).toList()).toList();
  }




}
