import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';

import '../../../../Database/local_database.dart';

class EventForm extends StatelessWidget {

  LocalDatabse mydb = LocalDatabse();

  final GlobalKey<FormState> key =  GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  EventForm({super.key});



  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    int id = 0;
    if(args != null && !args.isEmpty){
      name.text = args['name'];
      date.text = args['date'];
      location.text = args['location'];
      description.text = args['description'];
      id = args['id'];
    }
    return Template(
      title: "Event Form",
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Event Name
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(CupertinoIcons.pen),
                  labelText: "Event Name",
                  controller: name,
                ),
                const SizedBox(height: 16),

                /// Date
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.date_range),
                  labelText: "Date",
                  controller: date,
                ),
                const SizedBox(height: 16),

                /// Location
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.location_on),
                  labelText: "Location",
                  controller: location,
                ),
                const SizedBox(height: 16),

                /// Description
                InputField(
                  readOnly: false,
                  prefixIcon: const Icon(Icons.description),
                  labelText: "Description",
                  controller: description,
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        try {
                          int res;
                          print('args ${args}');
                          (args == null || args.isEmpty) ?
                            res = await mydb.insertData(
                              '''INSERT INTO 'EVENTS' ('NAME','DATE', 'LOCATION', 'DESCRIPTION', 'USERID')
                             VALUES ("${name.text}","${date.text}",
                             "${location.text}", "${description.text}", 1)''') :
                          res = await mydb.updateData(
                              '''UPDATE 'EVENTS' SET 
                              'NAME' = "${name.text}",
                              'DATE' = "${date.text}",
                              'LOCATION' = "${location.text}", 
                              'DESCRIPTION' = "${description.text}
                              WHERE ID= ${id}"''');
                          print("the event value is $res");
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Error. Sign up or login first')
                          ));
                          print("Error adding event :(" + e.toString());
                        }
                      }
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
