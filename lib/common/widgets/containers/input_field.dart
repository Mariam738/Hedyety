import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/my_theme.dart';




class InputField extends StatefulWidget {
  final String labelText;
  final bool readOnly;
  final Icon prefixIcon;
  final String initialValue;

  InputField({super.key, required this.initialValue, required this.readOnly, required this.labelText, required this.prefixIcon});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  Color _clr = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _clr = hasFocus ? MyTheme.primary : Colors.black
              // print(_clr);
              );
        },
        child: TextFormField(
          initialValue: widget.initialValue,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              prefixIconColor: _clr,
              labelText: widget.labelText,
              labelStyle: TextStyle(color: _clr),
              focusColor: MyTheme.primary,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.primary)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black))),
        ),
      ),
    );
  }
}
