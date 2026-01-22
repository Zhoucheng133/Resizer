import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/utils/controller.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Obx(()=>
              Image.file(File(controller.path.value))
            ),
          )
        ),
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.red
          ),
        )
      ]
    );
  }
}