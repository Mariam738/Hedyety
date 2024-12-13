import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hedyety/features/gift_management/models/event_model.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';

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
        var map = await publishUserGift(gifts[i], uid);
        await _fb.ref('/events/$uid/$key/gifts').set(map);
        // await _fb.ref('/events/$uid/$key/gifts').set(await publishUserGift(gifts[i], uid) as Map<String, Object>);
      }
      return true;
    } catch (e) {
      print('error in publishUserEvents $e');
      return false;
    }
  }

  Future<Map> publishUserGift(List gifts, String uid) async {
    Map<String, bool> map = {};
    for (int i = 0; i < gifts.length; i++) {
      String key;
      print('publishUserGift ${gifts[i].toJson()}');
      if (gifts[i].gid == null) {
        key = _fb.ref('/gifts/$uid').push().key!;
        GiftModel.editGid(key!, gifts[i].id!);
      } else
        key = gifts[i].gid;
      print('publishUserGift key $key');
      await _fb.ref('/gifts/$uid/$key').set(gifts[i].toJson());
      map[key] = true;
    }
    return map;
  }

  Future getFriendEventsByPhone(String phone) async {
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
    }
    print('getGiftsById $gifts');
    return gifts;
  }

  Future getGiftByUidAndGid(String uid, String gid) async {
    final snap = await _fb.ref('/gifts/$uid/$gid').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future pledgeGift(String uid, String friendid, String gid) async {
    await _fb.ref('/pledgedGifts/$uid').set({'friendId': friendid, 'gid': gid});
    await _fb.ref('/gifts/$friendid/$gid').update({'STATUS': 'pledged'});
    // TO DO sync user gift status with firebase maybe on login
  }

  Future getMyPledgedGifts(String uid) async {
    final snap = await _fb.ref('/gifpledgedGiftsts/$uid').get();
    if (snap.exists) return snap.value;
    return null;
  }

  Future getGiftStatus(String uid, String gid) async {
    final snap = await _fb.ref('/gifts/$uid/$gid/STATUS').get();
    print('getGiftStatus ${snap.value}');
    if (snap.exists) return snap.value;
    return null;
  }

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
