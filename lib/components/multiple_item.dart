import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resizer/utils/controller.dart';

class MultipleItem extends StatefulWidget {

  final MultipleConfigItem item;

  const MultipleItem({super.key, required this.item});

  @override
  State<MultipleItem> createState() => _MultipleItemState();
}

class _MultipleItemState extends State<MultipleItem> {

  bool hover=false;
  final Controller controller=Get.find();

  Future<void> itemMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      context: context,
      // 菜单位置
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        PopupMenuItem(
          height: 35,
          value: 'delete',
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.delete_rounded,
                size: 18,
              ),
              const SizedBox(width: 5,),
              Text('delete'.tr),
            ],
          ),
        ),
      ]
    );
    if(val=="delete"){
      controller.multipleConfigItems.remove(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => itemMenu(context, details),
      child: MouseRegion(
        onEnter: (_)=>setState(() {
          hover=true;
        }),
        onExit: (_)=>setState(() {
          hover=false;
        }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 65,
          decoration: BoxDecoration(
            color: hover ? Theme.brightnessOf(context)==Brightness.light ? Colors.grey[100] : Colors.grey[800] : null,
          ),
          child: Padding(
            padding: .symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.item.width == 0 ? '[AUTO]' : widget.item.width.toString(),
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                          Padding(
                            padding: .symmetric(horizontal: 5),
                            child: FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 14,
                            ),
                          ),
                          Text(
                            widget.item.height == 0 ? '[AUTO]' : widget.item.height.toString(),
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.folder_open_rounded,
                            size: 16,
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            widget.item.path,
                            style: TextStyle(
                              fontSize: 13
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ),
                Padding(
                  padding: .symmetric(horizontal: 10),
                  child: Icon(
                    widget.item.status==Status.done ? Icons.done_rounded : 
                    widget.item.status==Status.waiting ? Icons.timer_outlined :
                    widget.item.status==Status.running ? Icons.hourglass_bottom_rounded:
                    Icons.error_outline,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}