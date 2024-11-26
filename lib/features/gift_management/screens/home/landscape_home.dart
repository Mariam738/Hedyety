import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/landscape_template.dart';
import 'package:hedyety/features/gift_management/screens/home/home.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';

class LandscapeHome extends StatelessWidget {
  const LandscapeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LandscapeTemplate(
      child1: Home(),
      child2: Profile1(),
    );
  }
}