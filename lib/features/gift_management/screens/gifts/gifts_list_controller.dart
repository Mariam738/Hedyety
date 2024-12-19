import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';
import 'package:hedyety/main_controller.dart';
import 'package:hedyety/my_theme.dart';

class GiftsListController {
  static final GiftsListController _instance = GiftsListController._internal();

  LocalDatabse mydb = LocalDatabse();
  int id = 0;
  String? name;
  List myList = [];
  List filtered = [];
  var args;
  RealtimeDB fb = RealtimeDB();
  bool? isFriend;
  GlobalKey<AnimatedListState> giftAnimKey = GlobalKey();


  GiftsListController._internal();

void removeItem(int ind, String title, String subtitle) {
    giftAnimKey.currentState!.removeItem(ind, (_, anim) {
      return SizeTransition(
        sizeFactor: anim,
        child: Card(
          color: Colors.red.shade900,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));
    myList.removeAt(ind);
  }


  factory GiftsListController() {
    return _instance;
  }

  Future readGifts(isFiltered) async {
    // print('readEvents  here $isFiltered');
    if(isFiltered) return List<Map>;
    myList.clear();
    List<Map> res = await GiftModel.getGifts(id);
    myList.addAll(res);
    print('readGifts $myList');
    return myList;
  }

  Future<bool> deleteGift(int id, int ind, String title, String subtitle) async {
    int res = await GiftModel.deleteGift(id);
    if (res != null) {
      removeItem(ind, title, subtitle);
      return true;
    } else {
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(
          content: const Text('Error while deleting gift. Try again later.')));
      return false;
    }
  }

  void toFriendGift(String uid, String gid, String eid, String? status){
    print('toFriend $uid, $gid'); 
    MainController.navigatorKey.currentState!
        .pushNamed('/LgiftDetails', arguments: {'uid': uid,'gid':gid, 'eid': eid, 'status':status});
  }
  void toEdit(gift) {
      MainController.navigatorKey.currentState!
          .pushNamed('/LeditGiftForm', arguments: {
        "id": gift['ID'],
        "name": gift['NAME'],
        "description": gift['DESCRIPTION'],
        "category": gift['CATEGORY'],
        "price": gift['PRICE'],
        "eventid": gift['EVENTSID'],
      });
  }

  filter(bool isAscending, List category, List status) async {
    if(category. isEmpty) category = MyConstants.categoryList;
    if(status. isEmpty) status = MyConstants.eventStatusList;
    myList = await readGifts(false);
    print('myList $myList');
    
      isAscending
          ? myList.sort((a, b) {
              return a['NAME'].compareTo(b['NAME']);
            })
          : myList.sort((a, b) {
              return b['NAME'].compareTo(a['NAME']);
            });

      filtered = myList.where((e) => category.contains(e['CATEGORY'])).toList();
      MainController.navigatorKey.currentState!.pop();
      MainController.navigatorKey.currentState!.pushReplacementNamed('/LfilteredGiftsList');
      return filtered;
  }

  
  toAddGift() {
    MainController.navigatorKey.currentState!.pushReplacementNamed(
        '/LaddGiftForm',
        arguments: {'id': id, 'eventName': name});
  }
  
  Future readFriendGifts() async  {
    print(args);
    var res = await fb.getGiftsById(args['UID'], args['GIFTS']);
    myList = [];
    myList.addAll(res);
    return myList;
  }

  filterForFriend(bool isAscending, List category, List status) async {
    
      MainController.navigatorKey.currentState!.pop();
      MainController.navigatorKey.currentState!.pushReplacementNamed('/LfriendFilteredGiftsList', arguments:{'uid': args['uid'], 'eid':args['eid'], 'isAscending': isAscending, 'category':category, 'status': status});
      return filtered;
  }

  filterFriend() {
    bool isAscending = args['isAscending'];
    List category  = args['category'];
    List status = args['status'];
   if(category. isEmpty) category = MyConstants.categoryList;
    if(status. isEmpty) status = MyConstants.eventStatusList;
  isAscending
          ? myList.sort((a, b) {
              return a['NAME'].compareTo(b['NAME']);
            })
          : myList.sort((a, b) {
              return b['NAME'].compareTo(a['NAME']);
            });

      filtered = myList.where((e) => category.contains(e['CATEGORY'])).toList();
    myList = filtered;
    return;

  }
   getGiftStream() {
    return fb.getGiftStream(args['uid'], args['eid']);
  }

}
