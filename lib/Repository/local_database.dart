import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabse {
  static Database? _localDb;

  Future<Database?> get localDatabase async {
    if (_localDb == null) {
      _localDb = await initialize();
      return _localDb;
    } else {
      return _localDb;
    }
  }

  int Version = 1;

  initialize() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'myLocalDb.db');
    Database db =
        await openDatabase(path, version: Version, onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    }, onCreate: (db, Version) async {
      db.execute('''CREATE TABLE IF NOT EXISTS 'USERS' (
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'UID' TEXT,
      'NAME' TEXT,
      'EMAIL' TEXT,
      'PHONE' TEXT,
      'PREFERENCE' INTEGER)
      ''');

      db.execute('''CREATE TABLE IF NOT EXISTS 'EVENTS' (
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'NAME' TEXT,
      'DATE' TEXT,
      'LOCATION' TEXT,
      'DESCRIPTION' TEXT,
      'USERID' INTEGER,
      FOREIGN KEY(USERID) REFERENCES USERS(ID)
       )
      ''');

      db.execute('''CREATE TABLE IF NOT EXISTS 'GIFTS' (
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'NAME' TEXT,
      'DESCRIPTION' TEXT,
      'CATEGORY' TEXT,
      'PRICE' TEXT,
       'STATUS' TEXT,
      'EVENTSID' INTEGER,
      FOREIGN KEY(EVENTSID) REFERENCES EVENTS(ID)
       )
      ''');

      db.execute('''CREATE TABLE IF NOT EXISTS 'FRIENDS' (
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'USERID' INTEGER,
      'FRIENDID' INTEGER,
      FOREIGN KEY(USERID) REFERENCES USERS(ID),
      FOREIGN KEY(FRIENDID) REFERENCES USERS(ID)
       )
      ''');


      print("Database has been created .......");
    });
    return db;
  }

  readData(String SQL) async {
    Database? db = await localDatabase;
    var res = await db!.rawQuery(SQL);
    return res;
  }

  insertData(String SQL) async {
    Database? db = await localDatabase;
    int res = await db!.rawInsert(SQL);
    return res;
  }

  deleteData(String SQL) async {
    Database? db = await localDatabase;
    int res = await db!.rawDelete(SQL);
    return res;
  }

  updateData(String SQL) async {
    Database? db = await localDatabase;
    int res = await db!.rawUpdate(SQL);
    return res;
  }

  mydeletedatabase() async {
    String database = await getDatabasesPath();
    String path = join(database, 'myLocalDb.db');
    bool isExist = await databaseExists(path);
    if (isExist == true) {
      print('it exist');
    } else {
      print("it doesn't exist");
    }
    await deleteDatabase(path);
    print("MyData has been deleted");
  }
}
