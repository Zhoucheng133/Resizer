import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:resizer/components/config_item.dart';
import 'package:resizer/utils/controller.dart';

class ConfigSingle extends StatefulWidget {
  const ConfigSingle({super.key});

  @override
  State<ConfigSingle> createState() => _ConfigSingleState();
}

class _ConfigSingleState extends State<ConfigSingle> {

  final Controller controller=Get.find();

  final TextEditingController sizeWController = TextEditingController();
  final TextEditingController sizeHController = TextEditingController();

  bool lockRatio = true;

  Format format=Format.png;
  TextEditingController outputNameController=TextEditingController();

  double ratio = 1;

  bool invalidInput(String input){
    return !input.isNumericOnly || input.isEmpty || input.startsWith("0");
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
        )
      ],
    );
  }
}