import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/Repository/firebase_api.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';
import 'package:hedyety/main_controller.dart';
import 'package:image_picker/image_picker.dart';

class GiftDetailsController {
  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController category = TextEditingController();

  LocalDatabse mydb = LocalDatabse();
    RealtimeDB fb = RealtimeDB();
      final _auth = AuthService();

  String? firendGiftName;


  int? id;
  String? eventName;
  int? value = null;
  File? uploadedImage;
  var friendGift;
  void Function()? onValueChanged;

  void updateValue(){
    if(onValueChanged != null)
      onValueChanged!();
  }

  addGift() async {
     if(value== null) MainController.msngrKey.currentState!.showSnackBar(
              SnackBar(content: const Text('Remember to select a category.')));
    else if (key.currentState!.validate()) {
    int res = await GiftModel.addGift(name.text, description.text,
        MyConstants.categoryList[value!], price.text, id!);
        print('$res in  addGift');
    if (res != null) {
      print('addGifts $res');
     MainController.navigatorKey.currentState!.pushNamedAndRemoveUntil('/giftsList', (Route<dynamic> route) => false, arguments: {"id": id});
           print('addGifts $res');

    } else {
    print('error in addGift');
      MainController.msngrKey.currentState!.showSnackBar(
          SnackBar(content: const Text('Error adding gift. Try again later.')));
    }
    }
  }

  editGift() async {
     if(value== null) MainController.msngrKey.currentState!.showSnackBar(
              SnackBar(content: const Text('Remember to select a category.')));
    else if (key.currentState!.validate()) {
    int res = await GiftModel.editGift(name.text, description.text,
        MyConstants.categoryList[value!], price.text, id!);
    if (res != null) {
          MainController.navigatorKey.currentState!.pop();
    } else
      MainController.msngrKey.currentState!.showSnackBar(
          SnackBar(content: const Text('Error editing gift. Try again later.')));
    print("the event value is $res");
    }
  }

  Future uploadImage() async {
    final retImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (retImage == null) return;
    uploadedImage = File(retImage!.path);
  }

  Future getFriendGift(String uid, String gid) async {
    var res = await fb.getGiftByUidAndGid(uid, gid);
    name.text = res['NAME'];
    firendGiftName = res['NAME'];
    description.text = res['DESCRIPTION'];
    price.text = res['PRICE'];
    value =
          MyConstants.categoryList.indexWhere((e) => e == res['CATEGORY']);
    updateValue();
    friendGift = res;
    print('getFriendGift $res');
    return ;
  }

  Future pledgeGift(String friendid, String gid, String eid) async{
    try{
    await fb.pledgeGift(await _auth.getUserId()!,friendid, gid, eid);
      FirebaseApi().sendNotification(topic: friendid, title: "A gift is pledged:", body: "$firendGiftName", userId: "userId");

    MainController.msngrKey.currentState!.showSnackBar(SnackBar(content: Text('Gift pledged sucessfully')));

    
    } catch (e){
      print(e);
    }
    return;
  }
}
