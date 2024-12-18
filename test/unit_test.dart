import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Verify local database functions', () {
    WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    LocalDatabse mydb = LocalDatabse();
    late int res1;
    test('verify CRUD operations', () async {
      // verify insert and read
      String name = "me";
      String email = "me@gmail.com";
      String phone = "01234567891";
      String uid = "5qoefnrGUESAnVeO81jKkg5UveV2";
      int pref = 1;
      res1 = await mydb.insertData(
          '''INSERT INTO 'USERS' ('NAME','EMAIL', 'PHONE', 'UID', 'PREFERENCE') VALUES ('$name','$email','$phone','$uid' ,$pref)''');
      expect(res1, greaterThanOrEqualTo(1));
      var dbRes =
          await mydb.readData('''SELECT * FROM 'USERS' WHERE ID=$res1''');
      dbRes = dbRes[0];
      expect(dbRes['ID'], equals(res1));
      expect(dbRes['UID'], equals(uid));
      expect(dbRes['NAME'], equals(name));
      expect(dbRes['EMAIL'], equals(email));
      expect(dbRes['PHONE'], equals(phone));
      expect(dbRes['PREFERENCE'], equals(1));

      // verify update

      // verify delete
    });

    test('verify update ', () async {
      String name = "myNickName";
      String email = "mynickname@gmail.com";
      int res3 = await mydb.updateData('''UPDATE 'USERS' SET 'NAME' = "$name",
          'EMAIL' = "$email" WHERE ID= "$res1"''');
      expect(res3, equals(1));
      var dbRes =
          await mydb.readData('''SELECT * FROM 'USERS' WHERE ID=$res1''');
      dbRes = dbRes[0];
      expect(dbRes['NAME'], equals(name));
      expect(dbRes['EMAIL'], equals(email));
    });
    test('verify delete ', () async {
      int res4 =
          await mydb.deleteData('''DELETE FROM USERS WHERE ID= "$res1"''');
      expect(res4, equals(1));
      var dbRes =
          await mydb.readData('''SELECT * FROM 'USERS' WHERE ID=$res1''');
      expect(dbRes, []);
    });
  });
}
