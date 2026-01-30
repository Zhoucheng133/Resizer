import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/about.dart';
import 'package:resizer/components/settings_dialog.dart';

class FloatButtons extends StatefulWidget {
  const FloatButtons({super.key});

  @override
  State<FloatButtons> createState() => _FloatButtonsState();
}

class _FloatButtonsState extends State<FloatButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(10),
                bottomLeft: Radius.circular(10)
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          ),
          onPressed: ()=>showSettingsDialog(context), 
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(Icons.settings_rounded),
              SizedBox(width: 5,),
              Text("settings".tr),
            ],
          )
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          ),
          onPressed: ()=>showAbout(context), 
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(Icons.info_rounded),
              SizedBox(width: 5,),
              Text("about".tr),
            ],
          )
        ),
      ],
    );
  }
}