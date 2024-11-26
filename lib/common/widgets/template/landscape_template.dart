import 'package:flutter/material.dart';
import 'package:hedyety/features/gift_management/screens/home/home.dart';

class LandscapeTemplate extends StatelessWidget {
  const LandscapeTemplate(
      {super.key, required this.child1, required this.child2});

  final Widget child1;
  final Widget child2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(child: Home())
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.49,
          child: child1,
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 0.02),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.49,
          child: child2
          ),
      ],
    );
  }
}
