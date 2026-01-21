import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/utils/controller.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final Controller controller = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail){
        final filePath=detail.files.first.path;
        final ext = p.extension(filePath).toLowerCase();
        if(['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext)){
          controller.path.value = filePath;          
        }else{
          showOkDialog(context, "addImageFailed".tr, "formatError".tr);
        }
      },
      child: Center(
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.image,
                );
                if(result != null){
                  controller.path.value = result.files.single.path!;
                }
              }, 
              icon: const Icon(Icons.add_rounded)
            ),
            const SizedBox(height: 5,),
            Text("add".tr),
          ],
        ),
      ),
    );
  }
}