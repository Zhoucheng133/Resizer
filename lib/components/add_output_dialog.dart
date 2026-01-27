import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resizer/components/config_item.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';

bool isValidPath(String path) {
  if (path.trim().isEmpty) return false;

  final uri = Uri.tryParse(path);
  if (uri == null) return false;

  final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  if (!fileName.contains('.')) return false;

  final ext = fileName.split('.').last.toLowerCase();

  return Format.values
      .map((e) => e.name)
      .contains(ext);
}

Future<void> showAddOutputDialog(BuildContext context) async {

  MultipleConfigItem item = MultipleConfigItem("", 0, 0);
  final pathController = TextEditingController();
  final sizeWController = TextEditingController(text: item.width.toString(),);
  final sizeHController = TextEditingController(text: item.height.toString(),);
  final Controller controller=Get.find();
  Format format=Format.png;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('addOutput'.tr),
        content: StatefulBuilder(
          builder: (context, setState)=>SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: .min,
              children: [
                ConfigItem(
                  label: "path".tr, 
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pathController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            hintText: 'relativePath/name',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary.withAlpha(50)
                            )
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          onChanged: (val){
                            setState(() {
                              item.path = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            menuItemStyleData: MenuItemStyleData(
                              height: 35
                            ),
                            items: Format.values.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(".${e.name}"),
                                // child: Text(e.name),
                              );
                            }).toList(),
                            value: format,
                            onChanged: (Format? val){
                              if(val == null) return;
                              setState(() {
                                format = val;
                              });
                            }
                          )
                        ),
                      ),
                    ],
                  )
                ),
                ConfigItem(
                  label: "outputSize".tr, 
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: sizeWController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val){
                            if(val.isEmpty) return;
                            if(val.startsWith("0")){
                              setState(() {
                                item.width = 0;
                              });
                              return;
                            }
                            setState(() {
                              item.width = int.parse(val);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      FaIcon(FontAwesomeIcons.xmark),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: sizeHController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (val){
                            if(val.isEmpty) return;
                            if(val.startsWith("0")){
                              setState(() {
                                item.height = 0;
                              });
                              return;
                            }
                            setState(() {
                              item.height = int.parse(val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ConfigItem(
                  label: "", 
                  paddingSize: 0,
                  child: Text(
                    "sizeTip".tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ),
              ],
            ),
          )
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: (){
              if(pathController.text.isEmpty || !isValidPath("${pathController.text}.${format.name}")){
                showOkDialog(context, "error".tr, "invalidOutputPath".tr);
                return;
              }else if(sizeHController.text.isEmpty || sizeWController.text.isEmpty){
                showOkDialog(context, "error".tr, "invalidOutputSize".tr);
                return;
              }else if(sizeHController.text.startsWith("0") && sizeWController.text.startsWith("0")){
                showOkDialog(context, "error".tr, "invalidOutputSize".tr);
                return;
              }
              item.path = "${pathController.text}.${format.name}";
              controller.multipleConfigItems.add(item);
              controller.multipleConfigItems.refresh();
              Navigator.pop(context);
            }, 
            child: Text('add'.tr)
          )
        ]
      );
    }
  );
}