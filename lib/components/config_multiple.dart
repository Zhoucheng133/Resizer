import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizer/components/config_item.dart';
import 'package:resizer/utils/controller.dart';

class ConfigMultiple extends StatefulWidget {
  const ConfigMultiple({super.key});

  @override
  State<ConfigMultiple> createState() => _ConfigMultipleState();
}

class _ConfigMultipleState extends State<ConfigMultiple> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfigItem(
          label: "path".tr, 
          child: Text(
            controller.path.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ),
      ],
    );
  }
}