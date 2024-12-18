import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/switch/my_switch.dart';
import 'package:hedyety/common/widgets/containers/input_field.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile2.dart';
import 'package:hedyety/features/gift_management/screens/profile/profile1.dart';
import 'package:hedyety/my_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    /// Carousel Slilder
    return Column(
      children: [
        CarouselSlider(
          key: ValueKey('Slider'),
          items: [Profile1(), Profile2()],
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.95,
            onPageChanged: (value, _) {
              setState(() {
                _currentPage = value;
              });
            },
            viewportFraction: 1,
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xfffef7ff),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 2; i++)
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                        color:
                            i == _currentPage ? MyTheme.primary : Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
