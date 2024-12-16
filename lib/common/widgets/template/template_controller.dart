import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/common/custom_page_routes.dart';
import 'package:hedyety/features/authentication/screens/login.dart';
import 'package:hedyety/features/authentication/screens/sign_up.dart';
import 'package:hedyety/features/gift_management/screens/events_list/event_form.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list.dart';
import 'package:hedyety/features/gift_management/screens/gifts/my_pledge_gifts.dart';
import 'package:hedyety/features/gift_management/screens/home/home.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile.dart';
import 'package:hedyety/main_controller.dart';

class TemplateController {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  final _auth = AuthService();

  signout() {
    _auth.signOut();
    print('auth signout');
    MainController.navigatorKey.currentState!.pushReplacementNamed('/Rlogin');
  }

  goToHome() {
    MainController.navigatorKey.currentState!.popUntil((r) {
      r.settings.name.toString().toLowerCase().contains("home")
          ? MainController.navigatorKey.currentState!
              .pushReplacementNamed('/Lhome')
          : MainController.navigatorKey.currentState!
              .pushReplacementNamed('/Rhome');
      return true;
    });
  }

  goToEventsList() {
    var list = ['home', 'eventslist'];
    MainController.navigatorKey.currentState!.popUntil((r) {
      list.any((e)=> r.settings.name.toString().toLowerCase().contains(e))
          ? MainController.navigatorKey.currentState!
              .pushReplacementNamed('/LeventsList')
          : MainController.navigatorKey.currentState!
              .pushReplacementNamed('/ReventsList');
      return true;
    });
    // MainController.navigatorKey.currentState!
    //     .pushReplacementNamed('/eventsList');
   
  }

  goToMyPledgedGifts() {
    var list = ['home', 'eventslist', 'mypledgedgifts'];
    MainController.navigatorKey.currentState!.popUntil((r) {
      list.any((e)=> r.settings.name.toString().toLowerCase().contains(e))
          ? MainController.navigatorKey.currentState!
              .pushReplacementNamed('/LmyPledgedGifts')
          : MainController.navigatorKey.currentState!
              .pushReplacementNamed('/RmyPledgedGifts');
      return true;
    });

    // MainController.navigatorKey.currentState!
    //     .pushReplacementNamed('/myPledgedGifts');
  }

  goToProfile() {
     MainController.navigatorKey.currentState!.pushReplacementNamed('/Lprofile');
    
  }

  goToSignUp() {
    MainController.navigatorKey.currentState!.popUntil((r) {
      r.settings.name.toString().toLowerCase().contains("signup")
          ? MainController.navigatorKey.currentState!
              .pushReplacementNamed('/LsignUp')
          : MainController.navigatorKey.currentState!
              .pushReplacementNamed('/RsignUp');
      return true;
    });
  }

  goToLogin() {
    var list = ['signup', 'login'];
    MainController.navigatorKey.currentState!.popUntil((r) {
      list.any((e)=> r.settings.name.toString().toLowerCase().contains(e))
          ? MainController.navigatorKey.currentState!
              .pushReplacementNamed('/Llogin')
          : MainController.navigatorKey.currentState!
              .pushReplacementNamed('/Rlogin');
      return true;
    });
  }
}
