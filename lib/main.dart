import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/firebase_api.dart';
import 'package:hedyety/common/custom_page_routes.dart';
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
import 'package:firebase_analytics/firebase_analytics.dart';



import 'Repository/local_database.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await FirebaseApi().getAccessToken();
  // await FirebaseApi().handleBackgroundMessage;
  // FirebaseApi().sendNotification(fCMToken: "dIIUaNvnSnOFRkBt1nMbg8:APA91bHtRRUUpuQZ0Fzzl0alrYzfPtuoqxvqWXYDFH_CsowDQSM0PxgQ9rqsawS0L3WIK9exD10GJoIXTzvE4d5t0YAUbWkHAjyQo237CyvlPfjUFhijSCU", title: "title", body: "body", userId: "userId");
}

void main() {
  init();
  runApp(MyApp());
}



class MyApp extends StatelessWidget{
  // This widget is the root of your application.

  MainController controller = MainController();  

  // static Route onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case '/home':
  //       return CustomPageRoutes(child: chil)
        
  //   }
  // }
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
            onGenerateRoute: (settings) {
              print('ggggggg ${settings.name=='/LgiftsList'} ${settings.arguments}');
                if(settings.name =='/Lhome') return(CustomPageRoutes(child: Home(), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/Rhome') return(CustomPageRoutes(child: Home(), dir: AxisDirection.right, settings: settings));
                
                else if(settings.name =='/LeventsList') return(CustomPageRoutes(child: EventsList(isFriend: false), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/ReventsList') return(CustomPageRoutes(child: EventsList(isFriend: false), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LfriendEventsList') return(CustomPageRoutes(child: EventsList(isFriend: true), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/RfriendEventsList') return(CustomPageRoutes(child: EventsList(isFriend: true), dir: AxisDirection.right, settings: settings));

                else if(settings.name =='/LfilteredEventsList') return(CustomPageRoutes(child:  EventsList(isFriend: false, isFiltered: true,), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/RfilteredEventsList') return(CustomPageRoutes(child:  EventsList(isFriend: false, isFiltered: true,), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LfriendFilteredEventsList') return(CustomPageRoutes(child:  EventsList(isFriend: true, isFiltered: true,), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/RfriendFilteredEventsList') return(CustomPageRoutes(child:  EventsList(isFriend: true, isFiltered: true,), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LaddEventForm') return(CustomPageRoutes(child:  EventForm(isEdit: false), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/RaddEventForm') return(CustomPageRoutes(child:  EventForm(isEdit: false), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LeditEventForm') return(CustomPageRoutes(child:  EventForm(isEdit: true), dir: AxisDirection.left, settings: settings));
                else if(settings.name =='/ReditEventForm') return(CustomPageRoutes(child:  EventForm(isEdit: true), dir: AxisDirection.right, settings: settings));
                
                else if(settings.name =='/LgiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: false), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RgiftsList') return(CustomPageRoutes(child: GiftsList(isFriend: false), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LfilteredGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: false, isFiltered: true,), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RfilteredGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: false, isFiltered: true,), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LfriendGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: true), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RfriendGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: true), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LfriendFilteredGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: true, isFiltered: true), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RfriendFilteredGiftsList')return(CustomPageRoutes(child: GiftsList(isFriend: true, isFiltered: true), dir: AxisDirection.right, settings: settings));

                else if(settings.name =='/LaddGiftForm')return(CustomPageRoutes(child: GiftDetails(isFriend: false, isAdd: true, isEdit: false,), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RaddGiftForm')return(CustomPageRoutes(child: GiftDetails(isFriend: false, isAdd: true, isEdit: false,), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LeditGiftForm')return(CustomPageRoutes(child: GiftDetails(isFriend: false, isAdd: false, isEdit: true), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/ReditGiftForm')return(CustomPageRoutes(child: GiftDetails(isFriend: false, isAdd: false, isEdit: true), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LgiftDetails')return(CustomPageRoutes(child: GiftDetails(isFriend: true, isAdd: false, isEdit: false),dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RgiftDetails')return(CustomPageRoutes(child: GiftDetails(isFriend: true, isAdd: false, isEdit: false),dir: AxisDirection.right, settings: settings));

                else if(settings.name =='/Lprofile')return(CustomPageRoutes(child: Profile(), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/Rprofile')return(CustomPageRoutes(child: Profile(), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LmyPledgedGifts')return(CustomPageRoutes(child: MyPledgeGifts(), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RmyPledgedGifts')return(CustomPageRoutes(child: MyPledgeGifts(), dir: AxisDirection.right, settings: settings));

                else if(settings.name =='/Llogin')return(CustomPageRoutes(child: Login(), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/Rlogin')return(CustomPageRoutes(child: Login(), dir: AxisDirection.right, settings: settings));
                else if(settings.name =='/LsignUp')return(CustomPageRoutes(child: SignUp(), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RsignUp')return(CustomPageRoutes(child: SignUp(), dir: AxisDirection.right, settings: settings));

                else if(settings.name =='/LaddFriendFrom')return(CustomPageRoutes(child:  AddFriendForm(), dir: AxisDirection.left,settings: settings));
                else if(settings.name =='/RaddFriendFrom')return(CustomPageRoutes(child:  AddFriendForm(), dir: AxisDirection.right, settings: settings));
                
              

            },
            
            // initialRoute: home,
            routes: {
              '/home': (context) => Home(),

              '/eventsList': (context) => EventsList(isFriend: false),
              '/friendEventsList': (context) => EventsList(isFriend: true),

              '/filteredEventsList': (context) => EventsList(isFriend: false, isFiltered: true,),
              '/friendFilteredEventsList': (context) => EventsList(isFriend: true, isFiltered: true,),
              '/addEventForm': (context) => EventForm(isEdit: false),
              '/editEventForm': (context) => EventForm(isEdit: true),

              '/giftsList': (context) => GiftsList(isFriend: false),
              '/filteredGiftsList': (context) => GiftsList(isFriend: false, isFiltered: true,),
              '/friendGiftsList': (context) => GiftsList(isFriend: true),
              '/friendFilteredGiftsList': (context) => GiftsList(isFriend: true, isFiltered: true),

              '/addGiftForm': (context) => GiftDetails(isFriend: false, isAdd: true, isEdit: false,),
              '/editGiftForm': (context) => GiftDetails(isFriend: false, isAdd: false, isEdit: true),
              '/giftDetails': (context) => GiftDetails(isFriend: true, isAdd: false, isEdit: false),

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
