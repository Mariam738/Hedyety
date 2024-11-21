import 'package:flutter/material.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list.dart';
import 'package:hedyety/features/gift_management/screens/gifts/my_pledge_gifts.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile2.dart';
import 'package:hedyety/friend_gift_details.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gift_details.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gifts_list.dart';
import 'package:hedyety/features/gift_management/screens/home/home.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        //   '/': (context) => const Home(),

        '/eventsList': (context) => EventsList(isFriend: false),
        '/friendEventsList': (context) => EventsList(isFriend: true),

        '/giftsList': (context) => GiftsList(isFriend: false),
        '/friendGiftsList': (context) => GiftsList(isFriend: true),

        '/giftDetails': (context) => GiftDetails(isFriend: false),


        '/profile': (context) => Profile(),
        '/myPledgedGifts': (context) => MyPledgeGifts(),
      },
      theme: MyTheme.themeData,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
