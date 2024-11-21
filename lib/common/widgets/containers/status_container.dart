import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    super.key, required this.staus,
  });
  final String staus;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 5),
        child: Text("$staus", style: TextStyle(fontSize: 16,),),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.amber,
      ),
    );
  }
}
