import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String pass) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      return cred.user;
    } catch (e) {
      print("error in signUp AuthService ${e}");
      return null;
    }
  }

  Future<User?> loginIn(String email, String pass) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      return cred.user;
    } catch (e) {
      print("error in login AuthService ${e}");
      return null;
    }
  }

  Future<User?> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error in signOut AuthService ${e}");
    }
  }
}
