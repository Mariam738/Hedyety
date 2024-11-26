import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/common/widgets/template/template.dart';

class EventForm extends StatelessWidget {
  EventForm({super.key});

  final key = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Event Form",
      child: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                /// Event Name
                InputField(
                  initialValue: '',
                  readOnly: false,
                  prefixIcon: const Icon(CupertinoIcons.pen),
                  labelText: "Event Name",
                  controller: name,
                ),
                const SizedBox(height: 16),

                /// Date
                InputField(
                  initialValue: '',
                  readOnly: false,
                  prefixIcon: const Icon(Icons.date_range),
                  labelText: "Date",
                  controller: date,
                ),
                const SizedBox(height: 16),

                /// Location
                InputField(
                  initialValue: '',
                  readOnly: false,
                  prefixIcon: const Icon(Icons.location_on),
                  labelText: "Location",
                  controller: location,
                ),
                const SizedBox(height: 16),

                /// Description
                InputField(
                  initialValue: '',
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
                    onPressed: () {},
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
