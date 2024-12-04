import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/auth_service.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/authentication/controllers/signup_controller.dart';
import 'package:hedyety/features/authentication/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Repository/local_database.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  SignupController controller = SignupController(); 

  @override
  Widget build(BuildContext context) {
    return Template(
      showDrawer: false,
      title: "Signup",
      child: SingleChildScrollView(
        child: Form(
          key: controller.key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Username
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Username",
                  controller: controller.username,
                  // validator:
                ),
                const SizedBox(height: 16),

                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: controller.email,
                  validator: MyConstants.emailValidator,
                ),
                const SizedBox(height: 16),

                /// Phone
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.phone),
                  labelText: "Phone",
                  controller: controller.phone,
                ),
                const SizedBox(height: 16),

                /// Password
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.password),
                  labelText: "Password",
                  obscureText: true,
                  controller: controller.password,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.signup,
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
