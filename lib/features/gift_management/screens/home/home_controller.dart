import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:hedyety/Repository/realtime_db.dart';
import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/common/custom_page_routes.dart';
import 'package:hedyety/Repository/models/user_model.dart';
import 'package:hedyety/features/gift_management/screens/events_list/event_form.dart';
import 'package:hedyety/features/gift_management/screens/home/add_friend_form.dart';
import 'package:hedyety/main_controller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter/material.dart';

class HomeController {
  PhoneContact? contact;
  List friends = [];
  TextEditingController searchEditing = TextEditingController();
  RealtimeDB fb = RealtimeDB();

  final GlobalKey<AnimatedListState> homeAnimKey = GlobalKey<AnimatedListState>();

  // void addItem(item) {
  //   friends.add(item);
  //   homeAnimKey.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  // }

    void removeItem(int ind, String title, String subtitle) {
    homeAnimKey.currentState!.removeItem(ind, (_, anim) {
      return SizeTransition(
        sizeFactor: anim,
        child: Card(
          color: Colors.red.shade900,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
                            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 300));
    friends.removeAt(ind);
  }


  toAddFriendFrom() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/LaddFriendFrom');
  }

  toEventForm() {
    MainController.navigatorKey.currentState!.pushReplacementNamed('/LaddEventForm');
  }

  addContact() async {
    bool permission = await FlutterContactPicker.requestPermission();
    if (permission) {
      if (await FlutterContactPicker.hasPermission()) {
        contact = await FlutterContactPicker.pickPhoneContact();
        print('contact ${contact?.fullName}, ${contact?.phoneNumber?.number}');
        if (contact?.fullName != null && contact?.phoneNumber?.number != null) {
          UserModel.addContact(
              contact!.fullName!, contact!.phoneNumber!.number!);
        }
      }
    }
    getFriends();
  }

  syncFriendsUid() async {
    for(int i=0; i< friends.length; i++){
     if( friends[i]['UID'] == null){
      String? uid = await fb.getFriendIdByPhone(friends[i]['PHONE']);
      if(uid!=null){
        await UserModel.setUid(friends[i]['ID'], uid);
        friends[i]['ID']=uid;
      }
     }
    }
  }
  Future getFriends() async {
    friends = [];
    var res = await UserModel.getFriends(await SharedPref().getCurrentUid());
    friends.addAll(res);
    await syncFriendsUid();
    print('friends searchc ${searchEditing.text}');
    if (searchEditing.text.isEmpty == false && searchEditing.text != null)
      search(searchEditing.text.toLowerCase());
    print('friends $friends');
    return friends;
  }

  deleteFriend(int id, int ind, String title, String subtitle) async{
    var res = await UserModel.deleteFriend(id, await SharedPref().getCurrentUid());
      res != null
        ? removeItem(ind, title, subtitle)
        : MainController.msngrKey.currentState!.showSnackBar(SnackBar(
            content: const Text(
                'Delete all gifts associated with this event first.')));
  }

  search(String val) {
    friends = friends
        .where((e) => e['NAME'].toString().toLowerCase().contains(val))
        .toList();
    print('search $friends');
  }

  toFriendEvents(String phone) async {
    var res = await fb.getFriendIdByPhone(phone);
    if (res != null)
      MainController.navigatorKey.currentState!
          .pushReplacementNamed('/LfriendEventsList', arguments: {'uid': res});
    else
      MainController.msngrKey.currentState!.showSnackBar(SnackBar(
          content:
              Text('Sorry but your friend do not have Hedyety account.🙁')));
  }
  getEventStream(uid) {
    if(uid!=null)
    return fb.getEventStream(uid);
    return null;
  }
}
