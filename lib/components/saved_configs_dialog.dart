import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';

Future<void> showSavedConfigsDialog(BuildContext context) async {

  final Controller controller=Get.find();

  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text("savedConfigs".tr),
      content: StatefulBuilder(
        builder: (context, setState)=>SizedBox(
          width: 400,
          height: 350,
          child: Obx(()=>ListView.builder(
            itemCount: controller.savedConfigs.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(controller.savedConfigs[index].name),
                onTap: (){
                  controller.multipleConfigItems.value=[...controller.savedConfigs[index].list];
                  Navigator.of(context).pop();
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    if(await showOkCancelDialog(context, "removeConfig".tr, "removeConfigContent".tr)){
                      controller.removeSavedConfig(index);
                    }
                  },
                ),
              );
            }
          )),
        )
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
          child: Text("close".tr)
        ),
      ],
    )
  );
}