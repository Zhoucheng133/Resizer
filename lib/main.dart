import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:resizer/lang/en_us.dart';
import 'package:resizer/lang/zh_cn.dart';
import 'package:resizer/lang/zh_tw.dart';
import 'package:resizer/main_view.dart';
import 'package:resizer/utils/controller.dart';
import 'package:resizer/utils/handler.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(Handler());
  final controller=Get.put(Controller());
  await controller.init();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Resizer',
    minimumSize: Size(800, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final Controller controller=Get.find();

    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    controller.darkModeHandler(brightness == Brightness.dark);

    return Obx(
      ()=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MainTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', 'US'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        theme: ThemeData(
            brightness: controller.darkMode.value ? Brightness.dark : Brightness.light,
            fontFamily: 'PuHui', 
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: controller.darkMode.value ? Brightness.dark : Brightness.light,
            ),
            textTheme: controller.darkMode.value ? ThemeData.dark().textTheme.apply(
              fontFamily: 'PuHui',
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ) : ThemeData.light().textTheme.apply(
              fontFamily: 'PuHui',
            ),
          ),
        home: Scaffold(
          body: MainView()
        ),
      ),
    );
  }
}
