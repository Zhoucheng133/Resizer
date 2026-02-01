import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/utils/controller.dart';

Future<void> showLanguageDialog(BuildContext context) async { 

  final controller = Get.find<Controller>();

  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('language'.tr),
      content: Obx(()=>DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: supportedLocales.map((item)=>DropdownMenuItem(
            value: item.locale,
            child: Text(item.name)
          )).toList(),
          value: controller.lang.value.locale,
          onChanged: (value) => controller.changeLanguage(
            supportedLocales.indexWhere((item)=>item.locale == value)
          ),
        )
      )),
      actions: [
        ElevatedButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text("ok".tr)
        )
      ],
    ),
  );
}