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
              Column(
                mainAxisSize: .min,
                children: [
                  Image.file(File(controller.path.value)),
                  const SizedBox(height: 10),
                  Text("${controller.size.value.width.toInt()} (W) x ${controller.size.value.height.toInt()} (H)")
                ],
              )
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness==Brightness.dark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                
              ],
            ),
          ),
        )
      ]
    );
  }
}