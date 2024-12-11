import 'package:flutter/material.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1_controller.dart';
import 'package:hedyety/my_theme.dart';

class MySwitch extends StatefulWidget {
  // final Text text;
  bool value;
  String text;
  String altText;
  
  final void Function(bool)? onChanged;

  MySwitch({super.key, required this.text, required this.altText, required this.value, this.onChanged});

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
    Profile1Controller controller = Profile1Controller();


  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon>((states) =>
          states.contains(MaterialState.selected)
              ? const Icon(Icons.check)
              : const Icon(Icons.close));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.value ? widget.text : widget.altText),
        Switch(
          thumbIcon: thumbIcon,
          value: widget.value,
          onChanged: widget.onChanged ?? (bool val) {
            setState(() {
              widget.value = val;
              controller.notification = val;
            });
          },
          activeTrackColor: MyTheme.primary,
          inactiveTrackColor: Colors.white,
          // inactiveThumbColor: MyTheme.primary,
          inactiveThumbColor: MyTheme.primary,
          trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return MyTheme.primary;
          }),
        ),
      ],
    );
  }
}
