import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';
import 'package:hedyety/main_controller.dart';

class GiftsListController {
  static final GiftsListController _instance = GiftsListController._internal();

  LocalDatabse mydb = LocalDatabse();
  int id = 0;
  String? name;
  List myList = [];
  List filtered = [];

  GiftsListController._internal();

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

  Future<bool> deleteGift(int id) async {
    int res = await GiftModel.deleteGift(id);
    if (res != null) {
      await readGifts(false);
      return true;
    } else {
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(
          content: const Text('Error while deleting gift. Try again later.')));
      return false;
    }
  }

  void toEdit(gift) {
    MainController.navigatorKey.currentState!
        .pushNamed('/editGiftForm', arguments: {
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
      MainController.navigatorKey.currentState!.pushReplacementNamed('/filteredGiftsList');
      return filtered;
  }
  
  toAddGift() {
    MainController.navigatorKey.currentState!.pushReplacementNamed(
        '/addGiftForm',
        arguments: {'id': id, 'eventName': name});
  }
}
