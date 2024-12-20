import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/screens/home/add_friend_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

import '../../../../Repository/local_database.dart';


class AddFriendForm extends StatelessWidget {

  AddFriendController controller = AddFriendController();
  
  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Add Friend",
      child: SingleChildScrollView(
        child: Form(
          key: controller.key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Name
                InputField(
                readOnly: false,
                prefixIcon: const Icon(Icons.person),
                labelText: "Friend Name",
                controller: controller.name,
                validator: MyConstants.usernamaeValidator,
                ),
                const SizedBox(height: 16),
                /// Email
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.mail),
                  labelText: "Email",
                  controller: controller.email,
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
                  controller: controller.phone,
                  validator: MyConstants.phoneValidator,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()  {
                      controller.addFriend();
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
