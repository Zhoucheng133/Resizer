import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/config_multiple.dart';
import 'package:resizer/components/config_single.dart';
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
            child: Stack(
              children: [
                Obx(()=>
                  Column(
                    mainAxisAlignment: .center,
                    children: [
                      Image.file(File(controller.path.value)),
                      const SizedBox(height: 10),
                      Text("${controller.size.value.width.toInt()} (W) x ${controller.size.value.height.toInt()} (H)")
                    ],
                  )
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: (){
                      controller.path.value="";
                      controller.size.value=Size(0,0);
                    }, 
                    icon: Icon(Icons.close_rounded)
                  )
                )
              ],
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
            child: Obx(
              ()=> Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<Mode>(
                        segments: Mode.values.map((e) => ButtonSegment(
                          value: e,
                          label: Text(e.name.tr),
                        )).toList(),
                        selected: { controller.mode.value },
                        onSelectionChanged: (Set<Mode> newSelection) {
                          controller.mode.value = newSelection.first;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: controller.mode.value==Mode.single ?
                      ConfigSingle(key: Key("single"),) :
                      ConfigMultiple(key: Key("multiple"),),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]
    );
  }
}