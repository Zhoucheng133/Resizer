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
}

enum Status{
  waiting,
  running,
  done,
  error,
}

class MultipleConfigItem{
  String path;
  int width;
  int height;
  Status status=Status.waiting;
  MultipleConfigItem(this.path, this.width, this.height);

  factory MultipleConfigItem.fromJson(Map<String, dynamic> json){
    return MultipleConfigItem(json['path'], json['width'], json['height']);
  }

  Map<String, dynamic> toJson() => {
    'path': path,
    'width': width,
    'height': height,
  };

  @override
  bool operator ==(Object other) =>
      other is MultipleConfigItem &&
          other.path == path &&
          other.width == width &&
          other.height == height;
  
  @override
  int get hashCode => path.hashCode ^ width.hashCode ^ height.hashCode;
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