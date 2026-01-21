import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showOkDialog(BuildContext context, String title, String content) async {
  await showDialog(
    context: context, 
    builder: (BuildContext context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text("ok".tr)
        )
      ],
    )
  );
}