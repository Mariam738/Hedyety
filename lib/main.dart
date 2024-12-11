import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/landscape_template.dart';
import 'package:hedyety/features/authentication/screens/login.dart';
import 'package:hedyety/features/authentication/screens/sign_up.dart';
import 'package:hedyety/features/gift_management/screens/events_list/event_form.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list.dart';
import 'package:hedyety/features/gift_management/screens/gifts/my_pledge_gifts.dart';
import 'package:hedyety/features/gift_management/screens/home/add_friend_form.dart';
import 'package:hedyety/features/gift_management/screens/home/landscape_home.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile2.dart';
import 'package:hedyety/features/gift_management/screens/gifts/friend_gift_details.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gift_details.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gifts_list.dart';
import 'package:hedyety/features/gift_management/screens/home/home.dart';
import 'package:hedyety/main_controller.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Repository/local_database.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() {
  init();
  runApp(MyApp());
}



class MyApp extends StatelessWidget{
  // This widget is the root of your application.

  MainController controller = MainController();  


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.loadData(),
      builder: (BuildContext, snapshot){
        if(snapshot.hasData && snapshot.data != null) {
          return MaterialApp(
            title: 'Flutter Demo',
            navigatorKey: MainController.navigatorKey,
            scaffoldMessengerKey: MainController.msngrKey,
            // initialRoute: home,
            routes: {
              '/home': (context) => Home(),

              '/eventsList': (context) => EventsList(isFriend: false),
              '/filteredEventsList': (context) => EventsList(isFriend: false, isFiltered: true,),
              '/addEventForm': (context) => EventForm(isEdit: false),
              '/editEventForm': (context) => EventForm(isEdit: true),

              '/giftsList': (context) => GiftsList(isFriend: false),
              '/filteredGiftsList': (context) => GiftsList(isFriend: false, isFiltered: true,),
              '/friendGiftsList': (context) => GiftsList(isFriend: true),

              '/addGiftForm': (context) => GiftDetails(isFriend: false, isAdd: true, isEdit: false,),
              '/editGiftForm': (context) => GiftDetails(isFriend: false, isAdd: false, isEdit: true),
              '/giftDetails': (context) => GiftDetails(isFriend: true, isAdd: false, isEdit: true),


              '/profile': (context) => Profile(),
              '/myPledgedGifts': (context) => MyPledgeGifts(),

              '/signUp': (context) => SignUp(),
              '/login': (context) => Login(),

              '/addFriendFrom': (context) => AddFriendForm(),
            },
            theme: MyTheme.themeData,
            home: controller.isSignedUp! ? Login() : SignUp(),
            // home: Home(),
            debugShowCheckedModeBanner: false,
          );
        } else if(snapshot.hasError) {
          return Text("Error");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}
