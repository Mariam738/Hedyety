import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedyety/Repository/firebase_api.dart';
import 'package:hedyety/constants/constants.dart';

import 'package:hedyety/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-2-end test', () {
    testWidgets('Verify Pledge', (WidgetTester tstr) async {
      // Initialization and punping
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      // notification
      FirebaseMessaging.instance.requestPermission();
      // await tstr.tap(find.text('Allow'));
      await FirebaseApi().initNotification();
      await FirebaseApi().getAccessToken();

      int duration = 3;

      // sign up
      await tstr.pumpWidget(MyApp());
      await tstr.pumpAndSettle();
      await tstr.enterText(find.byType(TextField).at(0), '888888');
      await tstr.enterText(find.byType(TextField).at(1), '888888@gmail.com');
      await tstr.enterText(find.byType(TextField).at(2), '888888');
      await tstr.enterText(find.byType(TextField).at(3), '888888');
      await tstr.pump();
      await tstr.tap(find.text('✍ Sign Up ⬆️ '));
      await tstr.pump(Duration(seconds: duration));
      await tstr.pumpAndSettle();

      // login
      await tstr.enterText(find.byType(TextField).at(0), '888888@gmail.com');
      await tstr.enterText(find.byType(TextField).at(1), '888888');
      await tstr.tap(find.text('🔓 Log In ➡️ '));
      await tstr.pump(Duration(seconds: duration));
      await tstr.pumpAndSettle();

      // add friend
      await tstr.tap(find.text('Add Friend Manually'));
      await tstr.pumpAndSettle();
      await tstr.enterText(find.byType(TextField).at(0), '999999');
      await tstr.enterText(find.byType(TextField).at(1), '999999@gmail.com');
      await tstr.enterText(find.byType(TextField).at(2), '999999');
      await tstr.tap(find.text('➕ Add Friend 👱️ '));
      await tstr.pumpAndSettle();

      // pledge gift
      await tstr.pump(Duration(seconds: 30));
      for (int i = 0; i < 3; i++) {
        await tstr.tap(find.byType(Card));
        await tstr.pumpAndSettle();
      }
      await tstr.pumpAndSettle();

      await tstr.tap(find.text('🤝 Pledge Gift 🎁 '));

      // my pledged gifts
      await tstr.tap(find.byType(IconButton).at(0));
      await tstr.pumpAndSettle();
      await tstr.tap(find.text('My Pledged Gifts'));
      await tstr.pumpAndSettle();
      expect(find.text('pledged'), findsOne);
    });
  });
}
