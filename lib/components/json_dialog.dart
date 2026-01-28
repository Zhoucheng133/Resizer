import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';

bool checkJson(String json){
  final Controller controller = Get.find();
  try{
    Map<String, dynamic> jsonData=jsonDecode(json);
    if(jsonData.isEmpty){
      return false;
    }
    controller.multipleConfigItems.value=SavedConfig.fromJson(jsonData).list;
    return true;
  }catch(e){
    return false;
  }
}

void jsonCheckHandler(BuildContext context, String path){
  if(checkJson(File(path).readAsStringSync())){
    Navigator.pop(context);
  }else{
    showOkDialog(context, "error".tr, "invalidJson".tr);
  }
}

Future<void> showJsonDialog(BuildContext context) async {

  String filePath="";

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('addFromJson'.tr),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 400,
              child: SizedBox(
                height: 200,
                child: Center(
                  child: filePath.isEmpty ? Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                            allowMultiple: false
                          );
                          if(result != null){
                            setState(() {
                              filePath = result.files.single.path!;
                            });
                          }
                        }, 
                        icon: Icon(Icons.add_rounded),
                      ),
                      const SizedBox(height: 5,),
                      Text("addJsonFile".tr)
                    ],
                  ) : Text(filePath),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.of(context).pop(), 
            child: Text('cancel'.tr)
          ),
          TextButton(
            onPressed: (){
              jsonCheckHandler(context, filePath);
            }, 
            child: Text('loadOnly'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              jsonCheckHandler(context, filePath);
              // TODO 保存
            }, 
            child: Text('loadAndSave'.tr)
          )
        ],
      );
    }
  );
}