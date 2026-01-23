import 'dart:ui';

import 'package:get/get.dart';

enum Mode{
  single,
  multiple,
  json
}

class Controller extends GetxController {
  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  Rx<Mode> mode = Rx<Mode>(Mode.single);
}