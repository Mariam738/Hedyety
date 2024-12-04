import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Firebase {
  final FirebaseDatabase _fb = FirebaseDatabase.instance;

  Future<void> addUser(Map<String, dynamic> usr, String uid) async {
    await _fb.ref('/users/$uid').set(usr);
  }

  Future<void> addPhoneUser(Map<String, String> phone,String uid) async {
      await _fb.ref('/phones/$uid').set(phone);
  }
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseFirestore.instance.Settings = Settings(persistanceEnabled: tur)
  //
  // Future<void> addUser(name, email, phone) async {
  //   await _fires.collection('users').add({
  //     'name': name,
  //     'email': email,
  //     'phone': phone,
  //   });
  // }
  //
  //   Future<void> getUsers() async {
  //     QuerySnapshot<Map<String, dynamic>>? qSnap = await _firestore?.collection('users').get();
  //     for(var doc in qSnap.docs)
  //       print(doc.data());
  //   }

    // Future<void> addUser(name, email, phone) async {
    //
    // }


}
