import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

import '../../../../Database/local_database.dart';


class AddFriendForm extends StatelessWidget {

  LocalDatabse mydb = LocalDatabse();


  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Add 1Friend",
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Name
                InputField(
                readOnly: false,
                prefixIcon: const Icon(Icons.person),
                labelText: "Friend Name",
                controller: name,
                ),
                const SizedBox(height: 16),
                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: email,
                  validator: (value) {

                    if(value == null || value.isEmpty ||
                        (!value.endsWith("@gmail.com") &&
                            !value.endsWith("@hotmail.com")))
                      return "Field must end with @gmail.com or @hotmail.com";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Phone
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.phone),
                  labelText: "Phone",
                  controller: phone,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: const Text('Friend Added.')
                        // ));
                        try{
                          int response = await mydb.insertData(
                              '''INSERT INTO 'USERS' ('NAME','COMPANY-NAME','EMAIL') VALUES ("${name.text}","${email.text}","${phone.text}")''');
                          print("the value is $response");
                          // '''INSERT INTO 'BC' ('NAME','COMPANY-NAME','EMAIL') VALUES ("${Name.text}","${CompanyName.text}","${Email.text}")''');

                      Navigator.pushReplacementNamed(context, '/home');
                        } catch(e) {
                          print("Error adding friend :(" + e.toString());
                        }

                      }
                    },
                    child: const Text("➕ Add Friend 👱️ "),
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
