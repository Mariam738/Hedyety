// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/features/authentication/controllers/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

import '../../../Repository/auth_service.dart';
import '../../../constants/constants.dart';


class Login extends StatelessWidget {
  Login({super.key});

  LoginController controller = LoginController(); 

  @override
  Widget build(BuildContext context) {
    
    return Template(
      showDrawer: false,
      title: "Login",
      child: SingleChildScrollView(
        child: Form(
          key: controller.loginKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: controller.email2,
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
                  controller: controller.password2,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.loginKey.currentState!.validate()) {
                        controller.login();
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
