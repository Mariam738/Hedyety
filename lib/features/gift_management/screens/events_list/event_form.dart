import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/screens/events_list/event_form_controller.dart';
import 'package:hedyety/my_theme.dart';

import '../../../../Repository/local_database.dart';

class EventForm extends StatefulWidget {
  EventForm({super.key, required this.isEdit});

  final bool isEdit;
  

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  EventFormController controller = EventFormController();
  bool isSet = false;
  void didChangeDependencies() {
    super.didChangeDependencies();
     if (widget.isEdit == true && isSet == false) {
      isSet = true;
      Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && !args.isEmpty) {
        controller.isEdit = true;
        controller.name.text = args['name'];
        controller.date.text = args['date'];
        controller.location.text = args['location'];
        controller.description.text = args['description'];
        controller.category.text = args['category'];
        controller.id = args['id'];
        controller.value = MyConstants.eventsList.indexWhere((e) =>  e== args!['category']);
        print('setting contorller $args');
        args = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Template(
      title: "Event Form",
      child: SingleChildScrollView(
        child: Form(
          key: controller.key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            
            child: Column(
              children: [
                /// Event Name
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(CupertinoIcons.pen),
                  labelText: "Event Name",
                  controller: controller.name,
                ),
                const SizedBox(height: 16),

                /// Date
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.date_range),
                  labelText: "Date",
                  controller: controller.date,
                  validator: MyConstants.dateValidator,
                ),
                const SizedBox(height: 16),

                /// Location
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.location_on),
                  labelText: "Location",
                  controller: controller.location,
                ),
                const SizedBox(height: 16),

                /// Description
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.description),
                  labelText: "Description",
                  controller: controller.description,
                ),
                const SizedBox(height: 16),

                /// Event Category
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List<Widget>.generate(
                  MyConstants.eventsList.length,
                  (int index) {
                    return ChoiceChip(

                      label: Text(
                        '${MyConstants.eventsList[index]}',
                        style: TextStyle(
                            color:
                                index == controller.value ? Colors.white : Colors.black),
                      ),
                      selected: controller.value != null ? controller.value == index : false,
                      selectedColor: MyTheme.primary,
                      
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: MyTheme.primary)),
                        
                          
                      onSelected: (bool selected) {
                        setState(() {
                          controller.value = selected ? index : null;
                          if(controller.value !=null) {
                            print('value $controller.value ${MyConstants.eventsList[controller.value!]}');
                            controller.category.text = MyConstants.eventsList[controller.value!];
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


                /// Save Event Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.key.currentState!.save();
                      controller.saveEvent();
                    },
                    child: const Text("💾 Save Event Data 📌"),
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
