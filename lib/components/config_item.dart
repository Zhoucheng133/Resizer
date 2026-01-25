import 'package:flutter/material.dart';

class ConfigItem extends StatefulWidget {

  final String label;
  final Widget? labelWidget;
  final double paddingSize;
  final Widget child;
  final int labelWidth;

  const ConfigItem({super.key, required this.label, required this.child, this.labelWidth = 100, this.labelWidget, this.paddingSize=5.0});

  @override
  State<ConfigItem> createState() => _ConfigItemState();
}

class _ConfigItemState extends State<ConfigItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: widget.paddingSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.labelWidth.toDouble(),
            child: widget.labelWidget ?? Text(
              widget.label,
            ),
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}