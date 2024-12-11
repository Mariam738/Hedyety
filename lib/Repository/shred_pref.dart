import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  Future<int> getCurrentUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('currentUser')!;
  }
}