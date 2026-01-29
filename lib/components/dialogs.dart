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

Future<bool> showOkCancelDialog(BuildContext context, String title, String content, {String? cancelText, String? okText}) async {
  return await showDialog(
    context: context, 
    builder: (BuildContext context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(false), 
          child: Text(cancelText??"cancel".tr)
        ),
        ElevatedButton(
          onPressed: ()=>Navigator.of(context).pop(true), 
          child: Text(okText??"ok".tr),
        )
      ]
    )
  );
}