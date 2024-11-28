import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

import '../../../Database/auth_service.dart';
import '../../../constants/constants.dart';


class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? emailPref;

  String? passwordHashPref;

  Future loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    emailPref = pref.getString('email');
    passwordHashPref = pref.getString('password');

  }

  final GlobalKey<FormState> loginKey = GlobalKey();

  TextEditingController email2 = TextEditingController();

  TextEditingController password2 = TextEditingController();

  @override
  void initState() {
     loadData();
    super.initState();
  }

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    _login() async {
      try {
        final user = _auth.loginIn(email2.text, password2.text);
        if (user != null) {
          print("loged in");
          Navigator.pushReplacementNamed(context, '/home');
      }
      } catch(e) {
        // NO internet used shared prefrence instead
        email2.text == emailPref
            && sha512.convert(utf8.encode(password2.text)).toString() ==
            passwordHashPref ?
        Navigator.pushReplacementNamed(context, '/home') :
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Wrong Email or Password')
        ));
      }

    }

    return Template(
      title: "Login",
      child: SingleChildScrollView(
        child: Form(
          key: loginKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: email2,
                  validator: (value) {

                    if(value == null || value.isEmpty ||
                        (!value.endsWith("@gmail.com") &&
                            !value.endsWith("@hotmail.com")))
                      return "Field must end with @gmail.com or @hotmail.com";
                    return null;
                  },

                ),
                const SizedBox(height: 16),

                /// Password
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.password),
                  labelText: "Password",
                  controller: password2,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (loginKey.currentState!.validate()) {
                        _login();
                    }
                    },
                    child: const Text("🔓 Log In ➡️ "),
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
