import 'package:flutter/material.dart';

class CustomPageRoutes extends PageRouteBuilder{
  final Widget child;
  final AxisDirection dir;

  CustomPageRoutes({
    required this.child,
    this.dir = AxisDirection.right,
    RouteSettings? settings,
  }) : super(
    transitionDuration: Duration(seconds: 1),
    // reverseTransitionDuration: Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation)=> child,
    settings: settings
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, 
  Animation<double> secondaryAnimation) => 
    SlideTransition(position: Tween<Offset>(
      begin: getBeginOffset(),
      end: Offset.zero,
    ).animate(animation),
    child: child,);
  
  Offset getBeginOffset() {
    switch (dir) {
      case AxisDirection.up:
        return Offset(0, 1);
      case AxisDirection.down:
        return Offset(0, -1);
      case AxisDirection.right:
        return Offset(-1, 0);
      case AxisDirection.left:
        return Offset(1, 0);
    }
  }
  
}