import 'package:flutter/material.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';

/// Flutter code sample for [showModalBottomSheet].

void main() => runApp(const BottomSheetApp());

class BottomSheetApp extends StatelessWidget {
  const BottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Bottom Sheet Sample')),
        body: const SwitchExample(),
      ),
    );
  }
}
class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close, color: Colors.white,);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       
  //       Switch(
          
  //         activeTrackColor: MyTheme.primary,
  //         inactiveTrackColor: Colors.white,
  //         // inactiveThumbColor: MyTheme.primary,
  //         inactiveThumbColor: MyTheme.primary,trackOutlineColor:MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  //     return MyTheme.primary;
  //   // Use the default color.
  // }),
          
  //         thumbIcon: thumbIcon,
  //         value: light1,
  //         onChanged: (bool value) {
  //           setState(() {
  //             light1 = value;
  //           });
  //         },
  //       ),
  // MySwitch(),
      ],
    );
  }
}
