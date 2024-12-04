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

import '../../../../Repository/local_database.dart';

class GiftDetails extends StatefulWidget {
  GiftDetails({required this.isFriend,required this.isAdd, required this.isEdit });

  final bool isFriend;
  final bool isAdd;
  final bool isEdit;

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  File? _uploadedImage;
  bool _pledged = false;
  int? _value = 1;


  LocalDatabse mydb = LocalDatabse();

  final GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController category = TextEditingController();

  late final Map? args;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map?;
    if(widget.isEdit) {
      name.text = args!['name'];
      description.text = args!['description'];
      price.text = args!['price'];
      _value = MyConstants.categoryList.indexOf(args!['category']);

      print('gifts ${args!['id']}');
      // setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    Color _clr = Colors.black;
    bool isEditable = widget.isAdd || widget.isEdit|| _pledged == false;



      return Template(
      title: "Gift Details",
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              /// Uploaded Image
              if (_uploadedImage != null) Image.file(_uploadedImage!),

              /// Gift Name Field
              InputField(
                  readOnly: !isEditable,
                  labelText: "Gift Name",
                  prefixIcon: const Icon(CupertinoIcons.gift),
                  controller: name),
              const SizedBox(height: 16),

              /// Gift Description Field
              InputField(
                  readOnly: !isEditable,
                  labelText: "Gift Description",
                  prefixIcon: const Icon(Icons.description_outlined),
                  controller: description),
              const SizedBox(height: 16),

              /// Gift Price Field
              InputField(
                readOnly: !isEditable,
                labelText: "Gift Price",
                prefixIcon: const Icon(CupertinoIcons.money_dollar),
                controller: price,
              ),
              const SizedBox(height: 16),

              /// Gift Category
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
                          if(_value !=null) {
                            print('value $_value ${MyConstants.categoryList[_value!]}');
                            category.text = MyConstants.categoryList[_value!];
                            print(category.text);
                            key.currentState!.save();
                          }
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
              widget.isAdd
                  ? SizedBox.shrink()
                  : MySwitch(
                      value: !_pledged,
                      onChanged: (_) {},
                      text: "Status: Pledged. Cannot be modified.",
                      altText:
                          "Status: Available for editing. Not pledged yet.",
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      try {
                        int res;
                        if(widget.isAdd) {
                          res = await mydb.insertData(

                              '''INSERT INTO 'GIFTS' ('NAME','DESCRIPTION', 'CATEGORY', 'PRICE', 'EVENTSID')
                             VALUES ("${name.text}","${description.text}",
                             "${category.text}", "${price.text}", "${args!['id']}")''');
                          print("success adding gift details ");
                        }
                        if(widget.isEdit){
                          res = await mydb.updateData(
                              '''UPDATE 'GIFTS' SET 
                              'NAME' = "${name.text}",
                              'DESCRIPTION' = "${description.text}",
                              'CATEGORY' = "${MyConstants.categoryList[_value!]}", 
                              'PRICE' = "${price.text}"
                              WHERE ID= "${args!['id']}"''');
                          print("the event value is $res");
                        }
                        Navigator.pop(context);

                      } catch(e){
                        print("error adding gift details $e");
                      }
                      }
                  },
                  child: const Text("💾 Save Gift Data 📌"),
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
