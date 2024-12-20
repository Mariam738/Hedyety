import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gift_detail_controller.dart';
import 'package:hedyety/main.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../../../Repository/local_database.dart';

class GiftDetails extends StatefulWidget {
  GiftDetails(
      {required this.isFriend, required this.isAdd, required this.isEdit});

  final bool isFriend;
  final bool isAdd;
  final bool isEdit;

  @override
  State<GiftDetails> createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetails> {
  bool _pledged = false;


   Map? args;
  late GiftDetailsController controller;
  
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = GiftDetailsController();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    controller.onValueChanged = updateValue;
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map?;
      print('GiftDetails initialized with args: $args');
    if(widget.isFriend) {
      _pledged = true;
      //  controller.getFriendGift(args!['uid'], args!['gid']);
    }
    else{ if (widget.isEdit) {
      controller.name.text = args!['name'];
      controller.description.text = args!['description'];
      controller.price.text = args!['price'];
      controller.url.text = args!['url'];
      controller.uploadedImageUrl = args!['url'];
      controller.value =
          MyConstants.categoryList.indexWhere((e) => e == args!['category']);
      print('gifts ${args!['id']}');
      // setState(() {});
    }
    if(args?['status']!='Unpledged')_pledged = true;
    controller.id = args!['id'];
    controller.eventName = args!['eventName'];
    args=null;
    }
  }
  void updateValue(){
    if(mounted)
      setState(() {
      });
    }

  @override
  Widget build(BuildContext context) {
    Color _clr = Colors.black;
    bool isEditable = widget.isAdd || widget.isEdit || widget.isFriend ==false;
              // print('controller value ${controller.value}');
                    print('hereeee $args');
    if(widget.isAdd) _pledged = false;
    if(_pledged==true) isEditable = false;

    return Template(
      title: "Gift Details",
      child: SingleChildScrollView(
        child: Form(
          key: controller.key,
          child: Column(
            children: [
              /// Uploaded Image
              if (controller.uploadedImageUrl != null )
                // Image.file(controller.uploadedImage!),
                Image.network('${controller.uploadedImageUrl}'),

                if(widget.isFriend)
                 StreamBuilder(
                    stream: controller.getGiftStream(args?['uid'], args?['eid'], args?['gid']
                        ), // The stream to listen to
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Center(
                            child: CircularProgressIndicator(
                          color: MyTheme.primary,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error ${snapshot.error}"));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text("No data yet."));
                      }
                      {
                        Map<dynamic, dynamic> map =
                            snapshot.data?.snapshot.value as dynamic ?? {};
                            if (map.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(controller.name.text !=map['NAME'] || controller.description.text != map['DESCRIPTION'] 
                  || controller.price.text!= map['PRICE'] ||controller.value != MyConstants.categoryList.indexWhere((e) => e == map['CATEGORY'] 
                  ||args!['status']!=map['STATUS'] || map['URL']!=controller.uploadedImageUrl )){
                    controller.firendGiftName= map['NAME'];
                  controller.name.text= map['NAME']??"";
                        controller.description.text= map['DESCRIPTION']??"";
                        controller.price.text= map['PRICE']??"";
                        controller.value = MyConstants.categoryList.indexWhere((e) => e == map['CATEGORY']);
                        controller.uploadedImageUrl = map['URL'];
                        args!['status']=map['STATUS'];
                        print('${args!['status']}   dddddddddddddd ');
                        setState(() {});
                  }
                  
                });

              }
                     
                        
                        
                        // controller.myList.clear();
                        // controller.myList = list;
                        // if(widget.isFiltered== true){ controller.filterFriend();print('filtttttered ${controller.args}');}
                        // return Center(child: Text("$map"));
                        return SizedBox.shrink();
                      }
                        }
                 ),

              /// Gift Name Field
              InputField(
                  readOnly: !isEditable,
                  labelText: "Gift Name",
                  prefixIcon: const Icon(CupertinoIcons.gift),
                  controller: controller.name),
              const SizedBox(height: 16),

              /// Gift Description Field
              InputField(
                  readOnly: !isEditable,
                  labelText: "Gift Description",
                  prefixIcon: const Icon(Icons.description_outlined),
                  controller: controller.description),
              const SizedBox(height: 16),

              /// Gift Price Field
              InputField(
                readOnly: !isEditable,
                labelText: "Gift Price",
                prefixIcon: const Icon(CupertinoIcons.money_dollar),
                controller: controller.price,
                validator: MyConstants.priceValidator,

              ),
              const SizedBox(height: 16),
              if(widget.isFriend==false|| widget.isAdd || widget.isEdit)
              InputField(
                readOnly: !isEditable,
                labelText: "Image Url",
                prefixIcon: const Icon(Icons.web),
                controller: controller.url,
                validator: MyConstants.urlValidator,
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
                            color: index == controller.value
                                ? Colors.white
                                : Colors.black),
                      ),
                      selected: controller.value != null
                          ? controller.value == index
                          : false,
                      selectedColor: MyTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: MyTheme.primary)),
                      onSelected: (bool selected) {
                        if(widget.isFriend == false)
                        setState(() {
                          controller.value = selected ? index : null;
                          if (controller.value != null) {
                            print(
                                'value $controller.value ${MyConstants.eventsList[controller.value!]}');
                            controller.category.text =
                                MyConstants.eventsList[controller.value!];
                            print(controller.category.text);
                            controller.key.currentState!.save();
                          }
                        });
                      },
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 16),

              /// Gift Category
              // Wrap(
              //   spacing: 4,
              //   runSpacing: 4,
              //   children: List<Widget>.generate(
              //     MyConstants.categoryList.length,
              //     (int index) {
              //       return ChoiceChip(

              //         label: Text(
              //           '${MyConstants.categoryList[index]}',
              //           style: TextStyle(
              //               color:
              //                   index == _value ? Colors.white : Colors.black),
              //         ),
              //         selected: _value == index,
              //         selectedColor: MyTheme.primary,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(30),
              //             side: BorderSide(color: MyTheme.primary)),
              //         onSelected: (bool selected) {
              //           setState(() {
              //             _value = selected ? index : null;
              //             if(_value !=null) {
              //               print('value $_value ${MyConstants.categoryList[_value!]}');
              //               controller.category.text = MyConstants.categoryList[_value!];
              //               print(controller.category.text);
              //               controller.key.currentState!.save();
              //             }
              //           });
              //         },
              //       );
              //     },
              //   ).toList(),
              // ),
              // const SizedBox(height: 16),

              /// Status
              // Switch(
              //   value: !_pledged,
              //   activeColor: MyTheme.primar y,
              //   onChanged: (_) {},
              // ),
              // widget.isAdd || widget.isFriend
              //     ? SizedBox.shrink()
              //     : MySwitch(
              //         value: !_pledged,
              //         onChanged: (_) {},
              //         text: "Status: Pledged. Cannot be modified.",
              //         altText:
              //             "Status: Available for editing. Not pledged yet.",
              //       ),
              // const SizedBox(height: 16),

              /// Button
              /// Pledge Button
              widget.isFriend
                  ? (args!['status']=='Unpledged'
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('pledge $args');
                              controller.pledgeGift(args!['uid'], args!['gid'],args!['eid'] );
                            },
                            child: const Text("🤝 Pledge Gift 🎁 "),
                          ),
                        )
                      : SizedBox.shrink())
                  :

                  /// Upload Image
                  _pledged==false?
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_pledged) {
                            controller.uploadedImageUrl = controller.url.text;
                            // await controller.uploadImage();
                            setState(() {});
                          }
                        },
                        child: const Text("⬆️ Upload Image 📷"),
                      ),
                    ):SizedBox.shrink(),
              const SizedBox(height: 16),

              widget.isFriend || _pledged? SizedBox.shrink() :
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    print('here');
                    if (controller.key.currentState!.validate()) {
                      try {
                        int res;
                        if (widget.isAdd) {
                         await controller.addGift();

                        }
                        if (widget.isEdit) {
                          await controller.editGift();
                        }
                      } catch (e) {
                        print(
                            "error adding gift details $e \n id ${args!['id']}");
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
}
