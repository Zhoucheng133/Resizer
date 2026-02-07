import 'dart:convert';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageType{
  String name;
  Locale locale;

  LanguageType(this.name, this.locale);
}

List<LanguageType> get supportedLocales => [
  LanguageType("English", Locale("en", "US")),
  LanguageType("简体中文", Locale("zh", "CN")),
  LanguageType("繁體中文", Locale("zh", "TW")),
];

enum Mode{
  single,
  multiple,
}

enum Format{
  png,
  jpg,
  webp,
  gif,
}

enum Status{
  waiting,
  running,
  done,
  error,
}

class SavedConfig{
  String name;
  List<MultipleConfigItem> list;
  SavedConfig(this.name, this.list);

  factory SavedConfig.fromJson(Map<String, dynamic> json){
    if(
      json["name"] is! String || 
      json["list"] is! List ||
      !(json['list'] as List).every((e) => e is Map<String, dynamic>)||
      json["list"].length==0
    ){
      throw FormatException('JSON match ERR');
    }

    try {
      return SavedConfig(
        json['name'], 
        json['list'].map<MultipleConfigItem>((item) => MultipleConfigItem.fromJson(item)).toList()
      );
    } catch (e) {
      throw FormatException('JSON match ERR');
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'list': list.map((item) => item.toJson()).toList(),
  };
}

class MultipleConfigItem{
  String path;
  int width;
  int height;
  Status status=Status.waiting;
  MultipleConfigItem(this.path, this.width, this.height);

  factory MultipleConfigItem.fromJson(Map<String, dynamic> json){
    if(json["path"] is! String || (json["width"] is! int && json["width"] is! String) || (json["height"] is! int && json["height"] is! String)){
      throw FormatException('JSON match ERR');
    }

    try {
      if(json["width"] is String){
        json['width'] = int.parse(json['width']);
      }
      if(json["height"] is String){
        json['height'] = int.parse(json['height']);
      }
      
      return MultipleConfigItem(json['path'], json['width'], json['height']);
    } catch (e) {
      throw FormatException('JSON match ERR');
    }
  }

  Map<String, dynamic> toJson() => {
    'path': path,
    'width': width,
    'height': height,
  };

  @override
  bool operator ==(Object other) =>
      other is MultipleConfigItem &&
          other.path == path &&
          other.width == width &&
          other.height == height;
  
  @override
  int get hashCode => path.hashCode ^ width.hashCode ^ height.hashCode;
}

class Controller extends GetxController {

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    outputPath.value = prefs.getString("outputPath") ?? "";
    List<String>? savedConfigsPrefs = prefs.getStringList("savedConfigs");
    try {
      if(savedConfigsPrefs!=null){
        for (var item in savedConfigsPrefs) {
          savedConfigs.add(SavedConfig.fromJson(jsonDecode(item)));
        }
      }
    } catch (_) {
      savedConfigs.clear();
    }

    autoDark.value=prefs.getBool("autoDark") ?? true;
    darkMode.value=prefs.getBool("darkMode") ?? false;
    stretch.value=prefs.getBool("stretch") ?? true;

    int? langIndex=prefs.getInt("langIndex");

    if(langIndex==null){
      final deviceLocale=PlatformDispatcher.instance.locale;
      final local=Locale(deviceLocale.languageCode, deviceLocale.countryCode);
      int index=supportedLocales.indexWhere((element) => element.locale==local);
      if(index!=-1){
        lang.value=supportedLocales[index];
        lang.refresh();
      }
    }else{
      lang.value=supportedLocales[langIndex];
    }
  }

  void changeLanguage(int index){
    lang.value=supportedLocales[index];
    prefs.setInt("langIndex", index);
    lang.refresh();
    Get.updateLocale(lang.value.locale);
  }

  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  Rx<Mode> mode = Rx<Mode>(Mode.single);
  RxBool running = false.obs;
  RxString outputPath="".obs;
  RxList<MultipleConfigItem> multipleConfigItems = <MultipleConfigItem>[].obs;
  RxList<SavedConfig> savedConfigs = <SavedConfig>[].obs;
  Rx<LanguageType> lang=Rx(supportedLocales[0]);

  // 强制拉伸图片
  RxBool stretch=true.obs;
  
  RxBool autoDark = true.obs;
  RxBool darkMode = false.obs;

  void darkModeHandler(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }

  void setAutoDarkHandler(bool val, BuildContext context){
    autoDark.value=val;
    prefs.setBool("autoDark", autoDark.value);
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    if(brightness == Brightness.dark){
      darkMode.value=true;
    }else{
      darkMode.value=false;
    }
  }

  void setDarkModeHandler(bool dark){
    darkMode.value=dark;
    prefs.setBool("darkMode", darkMode.value);
  }

  void addSavedConfig(SavedConfig config){
    savedConfigs.add(config);
    prefs.setStringList("savedConfigs", savedConfigs.map((e) => jsonEncode(e.toJson())).toList());
  }

  void removeSavedConfig(int index){
    savedConfigs.removeAt(index);
    prefs.setStringList("savedConfigs", savedConfigs.map((e) => jsonEncode(e.toJson())).toList());
  }

  void setStretchHandler(bool val){
    stretch.value=val;
    prefs.setBool("stretch", stretch.value);
  }
}