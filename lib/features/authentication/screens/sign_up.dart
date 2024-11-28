import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Database/auth_service.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/authentication/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Database/local_database.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  LocalDatabse mydb = LocalDatabse();

  saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username.text);
    pref.setString('email', email.text);
    var digest = sha512.convert(utf8.encode(password.text));
    pref.setString('password', digest.toString());

    try {
      int response = await mydb.insertData(
          '''INSERT INTO 'USERS' ('NAME','EMAIL') VALUES ("${username.text}","${email.text}")''');
      print("the value is $response");
    } catch (e) {
      print("Error adding user :(" + e.toString());
    }
  }

  final GlobalKey<FormState> key = GlobalKey();

  TextEditingController username = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    _signup() async {
      if (key.currentState!.validate()) {
        // Form is valid
        final user = await _auth.signUp(email.text, password.text);
        if(user != null){
          print("successfult sign up");
          saveData();
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }

    return Template(
      title: "Signup",
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Username
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Username",
                  controller: username,
                  // validator:
                ),
                const SizedBox(height: 16),

                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: email,
                  validator: MyConstants.emailValidator,
                ),
                const SizedBox(height: 16),

                /// Password
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.password),
                  labelText: "Password",
                  obscureText: true,
                  controller: password,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signup,
                    child: const Text("✍ Sign Up ⬆️ "),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
