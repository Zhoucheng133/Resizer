import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resizer/main_view.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData(
          brightness: brightness,
          fontFamily: 'PuHui', 
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: brightness,
          ),
          textTheme: brightness==Brightness.dark ? ThemeData.dark().textTheme.apply(
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
    );
  }
}
