
import 'package:hedyety/Repository/local_database.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  bool? prefrence; // notification on/ off

  UserModel({this.name, this.email, this.phone, this.password, this.prefrence});

  static LocalDatabse mydb = LocalDatabse();

  static addContact(String name, String phone) async {
    try {
    int res = await mydb.insertData(
      '''INSERT INTO 'USERS' ('NAME','PHONE') VALUES ("$name","$phone")''');
    print('success in addContact $res');
    } catch (e) {
    print(e);
    }
  }

  static getFriends() async{
    List<Map> res=  await mydb.readData("SELECT * FROM 'USERS'");
    return res;
  }

  toJson(){
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'password' : password,
      'prefrence' : true,
    };
  }


  
}