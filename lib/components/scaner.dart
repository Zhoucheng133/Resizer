import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';
import 'package:resizer/utils/handler.dart';

Future<List<MultipleConfigItem>?> scanHandler(String path, BuildContext context) async {
  final Handler handler=Get.find();
  final rlt=await handler.readDir(path);
  if(rlt.startsWith("ERR") && context.mounted){
    showOkDialog(context, "error".tr, rlt);
    return null;
  }
  if(rlt.isEmpty) return null;
  try {
    List json=jsonDecode(rlt);
    if(json.isEmpty && context.mounted){
      showOkDialog(context, "noImageFound".tr, "tryAnotherDir".tr);
      return null;
    } 
    List<MultipleConfigItem> multipleConfigItems=json.map((item)=> MultipleConfigItem.fromJson(item)).toList();
    return multipleConfigItems;
  } catch (e) {
    if(context.mounted){
      showOkDialog(context, "error".tr, e.toString());
      return null;
    }
  }
  return null;
}

Future<void> showScanner(BuildContext context) async {

  List<MultipleConfigItem> multipleConfigItems=[];

  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('dirScan'.tr),
      content: StatefulBuilder(
        builder: (context, setState)=>SizedBox(
          width: 400,
          height: 300,
          child: multipleConfigItems.isEmpty ? Center(
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                const SizedBox(height: 15,),
                Text('selectDirToScan'.tr),
                const SizedBox(height: 5,),
                IconButton(
                  icon: Icon(Icons.add_rounded),
                  onPressed: () async {
                    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                    if(selectedDirectory!=null && context.mounted){
                      final data = await scanHandler(selectedDirectory, context) ?? [];
                      setState(() {
                        multipleConfigItems=data;
                      });
                    }
                  },
                )
              ],
            )
          ) : ListView.builder(
            itemCount: multipleConfigItems.length,
            itemBuilder: (context, index)=>Row(
              children: [
                Text(multipleConfigItems[index].width.toString()),
                Text(","),
                Text(multipleConfigItems[index].height.toString()),
              ],
            )
          ),
        )
      ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text('close'.tr)
        ),
      ],
    )
  );
}