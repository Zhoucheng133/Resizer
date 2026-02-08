import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final TextEditingController nameController=TextEditingController();

  await showDialog(
    context: context, 
    builder: (context)=>StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('dirScan'.tr),
          content: SizedBox(
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
            ) : Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    hintText: 'name'.tr,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: multipleConfigItems.length,
                    itemBuilder: (context, index)=>ListTile(
                      title: Row(
                        children: [
                          Text(multipleConfigItems[index].width.toString()),
                          Padding(
                            padding: .symmetric(horizontal: 5),
                            child: FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 14,
                            ),
                          ),
                          Text(multipleConfigItems[index].height.toString()),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 16,
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            multipleConfigItems[index].path,
                            style: TextStyle(
                              fontSize: 13
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          setState(() {
                            multipleConfigItems.removeAt(index);
                          });
                        }, 
                        icon: Icon(Icons.delete_rounded)
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()=>Navigator.of(context).pop(), 
              child: Text('close'.tr)
            ),
            if(multipleConfigItems.isNotEmpty) ElevatedButton(
              onPressed: (){
                if(nameController.text.isEmpty){
                  showOkDialog(context, "error".tr, "nameCannotBeEmpty".tr);
                  return;
                }
                SavedConfig config=SavedConfig(
                  nameController.text,
                  multipleConfigItems
                );
                final Controller controller=Get.find();
                if(controller.savedConfigs.indexWhere((item)=>item.name==config.name)!=-1){
                  showOkDialog(context, "error".tr, "configNameExists".tr);
                  return;
                }
                controller.addSavedConfig(config);
                Navigator.pop(context);
              }, 
              child: Text("save".tr)
            )
          ],
        );
      }
    )
  );
}