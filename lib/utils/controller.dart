import 'dart:ui';

import 'package:get/get.dart';

class Controller extends GetxController {
  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
}