import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:resizer/components/config_item.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';
import 'package:resizer/utils/handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigSingle extends StatefulWidget {
  const ConfigSingle({super.key});

  @override
  State<ConfigSingle> createState() => _ConfigSingleState();
}

class _ConfigSingleState extends State<ConfigSingle> {

  final Controller controller=Get.find();
  final Handler handler=Get.find();

  final TextEditingController sizeWController = TextEditingController();
  final TextEditingController sizeHController = TextEditingController();

  bool lockRatio = true;

  Format format=Format.png;
  TextEditingController outputNameController=TextEditingController();

  double ratio = 1;

  bool invalidInput(String input){
    return !input.isNumericOnly || input.isEmpty || input.startsWith("0");
  }

  Future<bool> checkTask(BuildContext context) async {
    if(outputNameController.text.isEmpty || outputNameController.text.contains(" ")){
      await showOkDialog(context, "error".tr, "invalidOutputName".tr);
      return false;
    }else if(controller.outputPath.value.isEmpty){
      await showOkDialog(context, "error".tr, "invalidOutputPath".tr);
      return false;
    }
    if(invalidInput(sizeWController.text) || invalidInput(sizeHController.text)){
      await showOkDialog(context, "error".tr, "invalidOutputSize".tr);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    sizeWController.text = controller.size.value.width.toInt().toString();
    sizeHController.text = controller.size.value.height.toInt().toString();
    outputNameController.text = p.basenameWithoutExtension(controller.path.value);
    setState(() {
      ratio = controller.size.value.width / controller.size.value.height;
    });
  }

  @override
  void dispose(){
    sizeWController.dispose();
    sizeHController.dispose();
    outputNameController.dispose();
    super.dispose();
  }

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
        ConfigItem(
          label: 'lockRatio'.tr,
          labelWidth: 90,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                splashRadius: 0,
                value: lockRatio, 
                onChanged: (val){
                  setState(() {
                    lockRatio = !lockRatio;
                  });
                  if(val && sizeWController.text.isNotEmpty){
                    setState(() {
                      sizeHController.text = (double.parse(sizeWController.text) / ratio).toInt().toString();
                    });
                  }
                }
              ),
            ),
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
                    enabledBorder: invalidInput(sizeWController.text) ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red ,
                      ),
                    ) : null,
                    focusedBorder: invalidInput(sizeWController.text) ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red ,
                        width: 2
                      ),
                    ) : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val){
                    setState(() {});
                    if(val.isEmpty) return;
                    if(val.startsWith("0")) return;
                    if(lockRatio){
                      setState(() {
                        sizeHController.text = (double.parse(val) / ratio).toInt().toString();
                      });
                    }
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
                    enabledBorder: invalidInput(sizeHController.text) ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red ,
                      ),
                    ) : null,
                    focusedBorder: invalidInput(sizeHController.text) ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red ,
                        width: 2
                      ),
                    ) : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val){
                    setState(() {});
                    if(val.isEmpty) return;
                    if(val.startsWith("0")) return;
                    if(lockRatio){
                      setState(() {
                        sizeWController.text = (double.parse(val) * ratio).toInt().toString();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        ConfigItem(
          label: "format".tr, 
          child: Align(
            alignment: .centerLeft,
            child: SizedBox(
              width: 100,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  menuItemStyleData: MenuItemStyleData(
                    height: 35
                  ),
                  items: Format.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
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
          )
        ),
        ConfigItem(
          label: "outputName".tr, 
          child: TextField(
            controller: outputNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            ),
            autocorrect: false,
            enableSuggestions: false,
          )
        ),
        ConfigItem(
          label: "", 
          paddingSize: 0,
          child: Text(
            "noExtNeeded".tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ),
        Expanded(child: Container()),
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
                if(await checkTask(context)){
                  controller.running.value = true;
                  final rlt=await handler.convert(controller.path.value, int.parse(sizeWController.text), int.parse(sizeHController.text), controller.outputPath.value, "${outputNameController.text}.${format.name}");
                  controller.running.value = false;
                  if(!rlt.contains("OK") && context.mounted){
                    await showOkDialog(context, "error".tr, rlt);
                  }else if(context.mounted){
                    await showOkDialog(context, "success".tr, "generateSuccess".tr);
                  }
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