import 'dart:ui';

import 'package:get/get.dart';

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
  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  Rx<Mode> mode = Rx<Mode>(Mode.single);
}