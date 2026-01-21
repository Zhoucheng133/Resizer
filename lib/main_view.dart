import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:resizer/utils/controller.dart';
import 'package:resizer/views/add_view.dart';
import 'package:resizer/views/config.dart';
import 'package:window_manager/window_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WindowListener {

  bool max=false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    super.onWindowMaximize();
    setState(() {
      max=true;
    });
  }

  @override
  void onWindowRestore() {
    super.onWindowRestore();
    setState(() {
      max=false;
    });
  }

  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              if(Platform.isWindows) Row(
                children: [
                  WindowCaptionButton.minimize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.minimize()
                  ),
                  max ? WindowCaptionButton.unmaximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.unmaximize()
                  ) : WindowCaptionButton.maximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.maximize()
                  ),  
                  WindowCaptionButton.close(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.close()
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(()=>
            controller.path.value.isEmpty ? AddView() : Config()
          )
        ),
        if(Platform.isMacOS) PlatformMenuBar(
          menus: [
            PlatformMenu(
              label: "Resizer",
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "关于 Resizer",
                      onSelected: (){
                        // TODO 显示关于
                      }
                    )
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "设置",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.comma,
                        meta: true,
                      ),
                      onSelected: (){
                        // TODO 前往设置
                      }
                    ),
                  ]
                ),
                const PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.hide,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.quit,
                    ),
                  ]
                ),
              ]
            ),
            PlatformMenu(
              label: "编辑",
              menus: [
                PlatformMenuItem(
                  label: "拷贝",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, CopySelectionTextIntent.copy);
                    }
                  }
                ),
                PlatformMenuItem(
                  label: "粘贴",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, const PasteTextIntent(SelectionChangedCause.keyboard));
                    }
                  },
                ),
                PlatformMenuItem(
                  label: "全选",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, const SelectAllTextIntent(SelectionChangedCause.keyboard));
                    }
                  }
                )
              ]
            ),
            const PlatformMenu(
              label: "窗口", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.minimizeWindow,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.toggleFullScreen,
                    )
                  ]
                )
              ]
            )
          ]
        )
      ],
    );
  }
}