import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await Process.run('adb', [ '-s', '0a0806530105', 'shell','pm', 'grant', 'com.example.hedyety', 'android.permission.POST_NOTIFICATIONS'],);
  await Process.run('adb', [ '-s', 'RK8WB005Z1F', 'shell','pm', 'grant', 'com.example.hedyety', 'android.permission.POST_NOTIFICATIONS'],);
  await integrationDriver();
}
