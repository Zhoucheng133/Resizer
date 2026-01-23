import 'package:flutter/material.dart';

class ConfigItem extends StatefulWidget {

  final String label;
  final Widget child;

  const ConfigItem({super.key, required this.label, required this.child});

  @override
  State<ConfigItem> createState() => _ConfigItemState();
}

class _ConfigItemState extends State<ConfigItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
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