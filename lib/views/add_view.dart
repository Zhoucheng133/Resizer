import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:resizer/components/dialogs.dart';
import 'package:resizer/components/float_buttons.dart';
import 'package:resizer/utils/controller.dart';
import 'package:resizer/utils/handler.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final Controller controller = Get.find();
  final Handler handler = Get.find();

  Future<void> fileHandler(String filePath, BuildContext context) async {
    final ext = p.extension(filePath).toLowerCase();
    if(['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext)){
      Size? size=await handler.getSize(filePath);
      if(size==null && context.mounted){
        showOkDialog(context, "addImageFailed".tr, "getSizeError".tr);
      }else if(size!=null){
        controller.size.value = size;
        controller.path.value = filePath;
      }
    }else{
      showOkDialog(context, "addImageFailed".tr, "formatError".tr);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail){
        final filePath=detail.files.first.path;
        fileHandler(filePath, context);
      },
      child: Stack(
        children: [
          Center(
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
                    if(result != null && context.mounted){
                      fileHandler(result.files.single.path!, context);
                    }
                  }, 
                  icon: const Icon(Icons.add_rounded)
                ),
                const SizedBox(height: 5,),
                Text("add_view_tip".tr),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatButtons()
          )
        ],
      ),
    );
  }
}