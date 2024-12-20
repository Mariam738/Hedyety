import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedyety/Repository/models/event_model.dart';
import 'package:hedyety/Repository/models/gift_model.dart';

class RealtimeDB {
  final FirebaseDatabase _fb = FirebaseDatabase.instance;

  Future<void> addUser(Map<String, dynamic> usr, String uid) async {
    await _fb.ref('/users/$uid').set(usr);
  }

  Future<void> addPhoneUser(String phone, String uid) async {
    await _fb.ref('/phones/$phone').set(uid);
  }

  Future<bool> publishUserEvents(
      List<EventModel> events, List gifts, String uid) async {
    try {
      await _fb.ref('/events/$uid').remove();
      await _fb.ref('/gifts/$uid').remove();
      for (int i = 0; i < events.length; i++) {
        var key;
        if (events[i].eid == null) {
          key = _fb.ref('/events/$uid').push().key;
          EventModel.editEid(key!, events[i].id!);
        } else
          key = events[i].eid;
        print('publishUserEvents $key');
        await _fb.ref('/events/$uid/$key').set(events[i].toJson());
        var map = await publishUserGift(gifts[i], uid, key);
        await _fb.ref('/events/$uid/$key/gifts').set(map);
        // await _fb.ref('/events/$uid/$key/gifts').set(await publishUserGift(gifts[i], uid) as Map<String, Object>);
      }
      return true;
    } catch (e) {
      print('error in publishUserEvents $e');
      return false;
    }
  }

  Future<Map> publishUserGift(List gifts, String uid, String eid) async {
    Map<String, bool> map = {};
    for (int i = 0; i < gifts.length; i++) {
      String key;
      print('publishUserGift ${gifts[i].toJson()}');
      if (gifts[i].gid == null) {
        key = _fb.ref('/gifts/$uid/$eid').push().key!;
        GiftModel.editGid(key!, gifts[i].id!);
      } else
        key = gifts[i].gid;
      print('publishUserGift key $key');
      await _fb.ref('/gifts/$uid/$eid/$key').set(gifts[i].toJson());
      map[key] = true;
    }
    return map;
  }

  Future getFriendIdByPhone(String phone) async {
    final snap = await _fb.ref('/phones/$phone').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future getEventsByUid(String uid) async {

    final snap = await _fb.ref('/events/$uid').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future getGiftsById(String uid, List id) async {
    List gifts = [];
    for (int i = 0; i < id.length; i++) {
      final snap = await _fb.ref('/gifts/$uid/${id[i]}').get();
      if (snap.exists) gifts.add(snap.value);
            final ref =  _fb.ref("/gifts/$uid/${id[i]}");
      ref.onChildChanged.listen((e){print('notification $e');});
    }
    print('getGiftsById $gifts');
    return gifts;
  }

  Future getGiftByUidAndGid(String uid, String gid) async {
    final snap = await _fb.ref('/gifts/$uid/$gid').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future pledgeGift(String uid, String friendid, String gid, String eid) async {
    await _fb.ref('/pledgedGifts/$uid/$gid').update({'friendId': friendid, 'eid': eid});
    await _fb.ref('/gifts/$friendid/$eid/$gid').update({'STATUS': 'Pledged'});
    // TO DO sync user gift status with firebase maybe on login
  }

  Future getMyPledgedGifts(String uid) async {
    final snap = await _fb.ref('/pledgedGifts/$uid').get();
    if (!snap.exists) return [];

    Map mymap = snap.value as Map;
    List<Map> list = mymap.entries.map((entry) {
    String id = entry.key as String ;
    Map<String, dynamic> data =Map<String, dynamic>.from(entry.value);
    return {
      "GID": id,
      "EID": data["eid"],
      "FID": data["friendId"],
    };
  }).toList();
    print('getMyPledgedGifts ${list}');
    List<Map<String, dynamic>> l = [];
    // get gift name and status
    for(int i = 0; i < list.length; i++) {
      var giftName = await getGiftNameById(list[i]['FID'], list[i]['GID']);
      var giftStatus = await getGiftStatus(list[i]['FID'],list[i]['EID'], list[i]['GID']);
      var eventDate = await getEventDateById(list[i]['FID'], list[i]['EID']);
      var firendName = await getUserNameById(list[i]['FID']);
      Map<String, dynamic> m = {'giftName' : giftName, 'giftStatus' : giftStatus, 'eventDate' : eventDate, 'firendName' : firendName, 
      'gid': list[i]['GID'], 'fid': list[i]['FID']};
      l.add(m);
    }
    return l;
  }

  Future getGiftNameById(String fid, String gid) async {
      final snap = await _fb.ref('/gifts/$fid/$gid/NAME').get();
      if (snap.exists) return snap.value;
         return null;
  }

  Future getEventDateById(String fid, String eid) async {
      final snap = await _fb.ref('/events/$fid/$eid/date').get();
      if (snap.exists) return snap.value;
         return null;
  }
  
  Future getGiftStatus(String uid, String eid, String gid) async {
    final snap = await _fb.ref('/gifts/$uid/$eid/$gid/STATUS').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future getUserNameById(String uid) async{
    final snap = await _fb.ref('/users/$uid/name').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future setGiftStatus(String friendid, String gid, String status) async {
    await _fb.ref('/gifts/$friendid/$gid').update({'STATUS': status});
  }

  // Streams 
  Stream<DatabaseEvent>? getEventStream(String uid){
    return _fb.ref('/events/$uid')?.onValue;
  }
  Stream<DatabaseEvent>? getFilteredEventStream(String uid){
    return _fb.ref('/events/$uid').orderByChild('name').onValue;
  }

  Stream<DatabaseEvent>? getGiftsStream(String uid, String eid){
    return _fb.ref('/gifts/$uid/$eid')?.onValue;
  }

   Stream<DatabaseEvent>? getGiftStream(String uid, String eid, String gid){
    return _fb.ref('/gifts/$uid/$eid/$gid')?.onValue;
  }


  // Future setFCMToken(String uid, String token) async {
  //   if((await _fb.ref('/users/$uid/token').get()).value !=null)
  //     await _fb.ref('/users/$uid').update({'token': token});

  // }

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseFirestore.instance.Settings = Settings(persistanceEnabled: tur)
  //
  // Future<void> addUser(name, email, phone) async {
  //   await _fires.collection('users').add({
  //     'name': name,
  //     'email': email,
  //     'phone': phone,
  //   });
  // }
  //
  //   Future<void> getUsers() async {
  //     QuerySnapshot<Map<String, dynamic>>? qSnap = await _firestore?.collection('users').get();
  //     for(var doc in qSnap.docs)
  //       print(doc.data());
  //   }

  // Future<void> addUser(name, email, phone) async {
  //
  // }
}
