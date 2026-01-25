import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/add_output_dialog.dart';
import 'package:resizer/components/config_item.dart';
import 'package:resizer/components/multiple_item.dart';
import 'package:resizer/utils/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigMultiple extends StatefulWidget {
  const ConfigMultiple({super.key});

  @override
  State<ConfigMultiple> createState() => _ConfigMultipleState();
}

class _ConfigMultipleState extends State<ConfigMultiple> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfigItem(
          label: "path".tr, 
          child: Text(
            controller.path.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ),
        Padding(
          padding: .symmetric(vertical: 5),
          child: Align(
            alignment: .centerLeft,
            child: Row(
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onPressed: ()=>showAddOutputDialog(context), 
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.add_rounded),
                      SizedBox(width: 5,),
                      Text('addOutput'.tr)
                    ],
                  )
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onPressed: (){
                    // TODO 添加输出
                  }, 
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.code_rounded),
                      SizedBox(width: 5,),
                      Text('fromJson'.tr)
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  onPressed: (){
                    // TODO 添加输出
                  }, 
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.save_rounded),
                      SizedBox(width: 5,),
                      Text('saved'.tr)
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(()=>
            ListView.builder(
              itemCount: controller.multipleConfigItems.length,
              itemBuilder: (context, index)=>MultipleItem(item: controller.multipleConfigItems[index],)
            )
          )
        ),
        ConfigItem(
          label: "outputPath".tr, 
          labelWidget: Align(
            alignment: .centerLeft,
            child: Icon(Icons.folder_rounded)
          ),
          labelWidth: 35,
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  ()=> Tooltip(
                    message: controller.outputPath.value,
                    child: TextField(
                      controller: TextEditingController(text: controller.outputPath.value),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      ),
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                  ),
                )
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () async {
                  String? path = await FilePicker.platform.getDirectoryPath();
                  if(path == null) return;
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("outputPath", path);
                  controller.outputPath.value = path;
                },
                child: Text("select".tr),
              ),
            ],
          )
        ),
        Padding(
          padding: .symmetric(vertical: 5),
          child: Obx(
            ()=> FilledButton(
              onPressed: controller.running.value ? null : () async {
                // TODO 运行
                // print(controller.multipleConfigItems);
                for (var element in controller.multipleConfigItems) {
                  print(element.toJson());
                }
              }, 
              child: controller.running.value ? Center(
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  )
                ),
              ) : Row(
                mainAxisAlignment: .center,
                children: [
                  Icon(Icons.play_arrow_rounded),
                  const SizedBox(width: 10,),
                  Text("generate".tr),
                ],
              )
            ),
          ),
        )
      ],
    );
  }
}