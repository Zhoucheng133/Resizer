import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';

SavedConfig? checkJson(String json){
  try{
    Map<String, dynamic> jsonData=jsonDecode(json);
    if(jsonData.isEmpty){
      return null;
    }
    return SavedConfig.fromJson(jsonData);
  }catch(e){
    return null;
  }
}

SavedConfig? jsonCheckHandler(BuildContext context, String path, bool save){
  final Controller controller = Get.find();
  final SavedConfig? config=checkJson(File(path).readAsStringSync());
  if(config!=null){
    if(save && controller.savedConfigs.indexWhere((item)=>item.name==config.name)!=-1){
      showOkDialog(context, "error".tr, "configNameExists".tr);
      return null;
    }
    controller.multipleConfigItems.value=config.list;
    return config;
  }else{
    showOkDialog(context, "error".tr, "invalidJson".tr);
    return null;
  }
}

Future<void> showJsonDialog(BuildContext context) async {

  String filePath="";
  final Controller controller = Get.find();

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
              final SavedConfig? config=jsonCheckHandler(context, filePath, false);
              if(config!=null){
                Navigator.pop(context);
              }
            }, 
            child: Text('loadOnly'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              final SavedConfig? config=jsonCheckHandler(context, filePath, true);
              if(config!=null){
                controller.addSavedConfig(config);
                Navigator.pop(context);
              }
            }, 
            child: Text('loadAndSave'.tr)
          )
        ],
      );
    }
  );
}