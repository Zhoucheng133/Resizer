import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Mode{
  single,
  multiple,
  json
}

enum Format{
  png,
  jpg,
  webp,
  gif,
  svg,
}

class Controller extends GetxController {

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    outputPath.value = prefs.getString("outputPath") ?? "";
  }

  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  Rx<Mode> mode = Rx<Mode>(Mode.single);
  RxBool running = false.obs;
  RxString outputPath="".obs;
}