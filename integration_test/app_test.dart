import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
      await tstr.enterText(find.byType(TextField).at(0), '999999');
      await tstr.enterText(find.byType(TextField).at(1), '999999@gmail.com');
      await tstr.enterText(find.byType(TextField).at(2), '999999');
      await tstr.enterText(find.byType(TextField).at(3), '999999');
      await tstr.pump();
      await tstr.tap(find.text('✍ Sign Up ⬆️ '));
      await tstr.pump(Duration(seconds: duration));
      await tstr.pumpAndSettle();

      // login
      await tstr.enterText(find.byType(TextField).at(0), '999999@gmail.com');
      await tstr.enterText(find.byType(TextField).at(1), '999999');
      await tstr.tap(find.text('🔓 Log In ➡️ '));
      await tstr.pump(Duration(seconds: duration));
      await tstr.pumpAndSettle();

      // add event
      await tstr.tap(find.byType(IconButton).at(1));
      await tstr.pumpAndSettle();
      await tstr.tap(find.text('My Events'));
      await tstr.pumpAndSettle();
      await tstr.tap(find.text('➕ Add New Event 📅'));
      await tstr.pumpAndSettle();
      String eventName = 'Test Event';
      await tstr.enterText(find.byType(TextField).at(0), eventName);
      await tstr.enterText(find.byType(TextField).at(1), '12-12-2025');
      await tstr.enterText(find.byType(TextField).at(2), 'Maadi');
      await tstr.enterText(find.byType(TextField).at(3),
          'This event will be used for testing purposes only.');
      await tstr.testTextInput.receiveAction(TextInputAction.done);
      await tstr.pumpAndSettle();
      await tstr.tap(find.text((MyConstants.eventsList[0])));
      await tstr.tap(find.text('💾 Save Event Data 📌'));
      await tstr.pumpAndSettle();

      // add gift
      await tstr.tap(find.text(eventName));
      await tstr.pumpAndSettle();
      await tstr.tap(find.text('➕ Add New Gift 🎁'));
      await tstr.pumpAndSettle();
      await tstr.enterText(find.byType(TextField).at(0), 'Test Gift');
      await tstr.enterText(
          find.byType(TextField).at(1), 'Test Gift Description');
      await tstr.enterText(find.byType(TextField).at(2), '100');
      await tstr.testTextInput.receiveAction(TextInputAction.done);
      await tstr.tap(find.text(MyConstants.categoryList[0]));
      await tstr.tap(find.text('💾 Save Gift Data 📌'));
      await tstr.pumpAndSettle();

      // publish
      await tstr.tap(find.byType(IconButton).at(2));
      await tstr.pumpAndSettle();
      await tstr.tap(find.text('Profile'));
      await tstr.pumpAndSettle();

      await tstr.fling(
          find.byKey(ValueKey('Slider')), const Offset(400, 0), 300.0);
      await tstr.pump();
      await tstr
          .pump(const Duration(seconds: 2)); // finish the scroll animation
      await tstr.pump(
          const Duration(seconds: 2)); // finish the indicator settle animation
      await tstr.pump(
          const Duration(seconds: 2)); // finish the indicator hide animation
      await tstr.pumpAndSettle();
      // tstr.dragUntilVisible(find.text('⬆️ Publish 📢'),find.text('Notifications'),Offset(-300, 0) );
      await tstr.tap(find.text('⬆️ Publish 📢'));
      await tstr.pumpAndSettle();

      await tstr.pump(Duration(seconds: duration));
      await tstr.pump(Duration(seconds: 45));
      await tstr.pumpAndSettle();
      expect(find.text('🔔New notification \nA gift is pledged:\nTest Gift'), findsOne);
      // await tstr.pump(Duration(minutes: 2));
    });
  });
}
