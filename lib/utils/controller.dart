import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Mode{
  single,
  multiple,
}

enum Format{
  png,
  jpg,
  webp,
  gif,
  svg,
}

enum Status{
  waiting,
  running,
  done,
  error,
}

class MultipleConfigItem{
  String name;
  String path;
  int width;
  int height;
  Status status=Status.waiting;
  MultipleConfigItem(this.name, this.path, this.width, this.height);

  MultipleConfigItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        path = json['path'],
        width = json['width'],
        height = json['height'];

  Map toJson() => {
    'name': name,
    'path': path,
    'width': width,
    'height': height,
  };
}

class Controller extends GetxController {

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    outputPath.value = prefs.getString("outputPath") ?? "";
  }

  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  // TODO 临时修改
  Rx<Mode> mode = Rx<Mode>(Mode.multiple);
  RxBool running = false.obs;
  RxString outputPath="".obs;
  RxList<MultipleConfigItem> multipleConfigItems = <MultipleConfigItem>[].obs;
}