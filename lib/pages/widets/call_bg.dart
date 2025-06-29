import 'package:bloctry/styles/colors.dart';
import 'package:flutter/material.dart';

class CallBG extends StatelessWidget {
  const CallBG({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.green,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 24),
      child: TextButton.icon(
        onPressed: () {},
        label: Text(
          "Call",
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.call, color: Colors.white),
      ),
    );
  }
}
