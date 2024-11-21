import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/my_theme.dart';
import 'package:image_picker/image_picker.dart';

class FriendGiftDetails extends StatefulWidget {
  const FriendGiftDetails({super.key});

  @override
  State<FriendGiftDetails> createState() => _FriendGiftDetailsState();
}

class _FriendGiftDetailsState extends State<FriendGiftDetails> {
  bool _pledged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift Name Details"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Image
                Container(
                  width: 125,
                  height: 125,
                  child: Image.network(
                      'https://play-lh.googleusercontent.com/JFsWuM7yWlTxhoddyAA5eLAaS92hjJz5-hAa-82o8hMr2Kbeg8yDzIounvNSNCTYNg'),
                ),
        
                /// Gift Name Field
                TextFormField(
                  initialValue: 'Dumy Value',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.gift),
                    labelText: "Gift Name",
                  ),
                ),
                const SizedBox(height: 16),
        
                /// Gift Description Field
                TextFormField(
                  initialValue: 'Dumy Value',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description_outlined),
                    labelText: "Gift Description",
                  ),
                ),
                const SizedBox(height: 16),
        
                /// Gift Category Field
                TextFormField(
                  initialValue: 'Dumy Value',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                    labelText: "Gift Category",
                  ),
                ),
                const SizedBox(height: 16),
        
                /// Gift Price Field
                TextFormField(
                  initialValue: 'Dumy Value',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.money_dollar),
                    labelText: "Gift Price",
                  ),
                ),
                const SizedBox(height: 16),
        
                /// Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Status: ${_pledged ? "Not available for pledging " : "Available for pledging "}"),
                    Switch(
                      value: !_pledged,
                      activeColor: MyTheme.primary,
                      onChanged: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
        
                /// Pledge Button
                if (!_pledged)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("🤝 Pledge Gift 🎁 "),
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
