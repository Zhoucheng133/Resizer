import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/utils/controller.dart';

void showSettingsDialog(BuildContext context) async {

  final controller = Get.find<Controller>();
  
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('settings'.tr),
      content: Column(
        mainAxisSize: .min,
        children: [
          Row(
            children: [
              Text('autoDark'.tr),
              Expanded(
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Obx(
                    ()=> Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.autoDark.value, 
                        splashRadius: 0,
                        onChanged: (bool value){
                          controller.setAutoDarkHandler(value, context);
                        }
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('darkMode'.tr),
              Expanded(
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Obx(
                    ()=> Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: controller.darkMode.value, 
                        splashRadius: 0,
                        onChanged: controller.autoDark.value ? null : (bool value){
                          controller.setDarkModeHandler(value);
                        }
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
          child: Text('ok'.tr)
        ),
      ],
    )
  );
}