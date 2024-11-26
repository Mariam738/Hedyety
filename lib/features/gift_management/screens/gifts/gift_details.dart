import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/main.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class GiftDetails extends StatefulWidget {
  GiftDetails({super.key, required this.isFriend});
  final bool isFriend;

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  File? _uploadedImage;
  bool _pledged = true;
  int? _value = 1;


  final key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController category = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Color _clr = Colors.black;

    return Template(
      title: "Gift Name Details",
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              /// Uploaded Image
              if (_uploadedImage != null) Image.file(_uploadedImage!),

              /// Gift Name Field
              InputField(
                  initialValue: "Scarf",
                  readOnly: _pledged,
                  labelText: "Gift Name",
                  prefixIcon: const Icon(CupertinoIcons.gift),
                  controller: name
              ),
              const SizedBox(height: 16),

              /// Gift Description Field
              InputField(
                  initialValue: "Dummy value",
                  readOnly: _pledged,
                  labelText: "Gift Description",
                  prefixIcon: const Icon(Icons.description_outlined),
                  controller: description
              ),
              const SizedBox(height: 16),

              /// Gift Price Field
              InputField(
                  initialValue: "Dummy value",
                  readOnly: _pledged,
                  labelText: "Gift Price",
                  prefixIcon: const Icon(CupertinoIcons.money_dollar),
                  controller: price,
              ),
              const SizedBox(height: 16),

              /// Gift Category Field
              InputField(
                  initialValue: "Dummy value",
                  readOnly: _pledged,
                  labelText: "Gift Category",
                  prefixIcon: const Icon(Icons.category_outlined),
                  controller: category
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List<Widget>.generate(
                  MyConstants.categoryList.length,
                  (int index) {
                    return ChoiceChip(
                      label: Text(
                        '${MyConstants.categoryList[index]}',
                        style: TextStyle(
                            color:
                                index == _value ? Colors.white : Colors.black),
                      ),
                      selected: _value == index,
                      selectedColor: MyTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: MyTheme.primary)),
                      onSelected: (bool selected) {
                        setState(() {
                          _value = selected ? index : null;
                        });
                      },
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 16),

              /// Status
              // Switch(
              //   value: !_pledged,
              //   activeColor: MyTheme.primary,
              //   onChanged: (_) {},
              // ),
              MySwitch(
                value: !_pledged,
                onChanged: (_) {},
                text: "Status: Pledged. Cannot be modified.",
                altText: "Status: Available for editing. Not pledged yet.",
              ),
              const SizedBox(height: 16),

              /// Button
              /// Pledge Button
              widget.isFriend
                  ? (!_pledged
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("🤝 Pledge Gift 🎁 "),
                          ),
                        )
                      : SizedBox.shrink())
                  :
                  /// Upload Image
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_pledged) _uploadImage();
                        },
                        child: const Text("⬆️ Upload Image 📷"),
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future _uploadImage() async {
    final retImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (retImage == null) return;
    setState(() {
      _uploadedImage = File(retImage!.path);
    });
  }
}
