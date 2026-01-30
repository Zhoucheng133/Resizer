import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if(json["path"] is! String || json["width"] is! int || json["height"] is! int){
      throw FormatException('JSON match ERR');
    }
    
    return MultipleConfigItem(json['path'], json['width'], json['height']);
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
  }

  RxString path = "".obs;
  Rx<Size> size = Size(0, 0).obs;
  Rx<Mode> mode = Rx<Mode>(Mode.single);
  RxBool running = false.obs;
  RxString outputPath="".obs;
  RxList<MultipleConfigItem> multipleConfigItems = <MultipleConfigItem>[].obs;
  RxList<SavedConfig> savedConfigs = <SavedConfig>[].obs;

  void addSavedConfig(SavedConfig config){
    savedConfigs.add(config);
    prefs.setStringList("savedConfigs", savedConfigs.map((e) => jsonEncode(e.toJson())).toList());
  }

  void removeSavedConfig(int index){
    savedConfigs.removeAt(index);
    prefs.setStringList("savedConfigs", savedConfigs.map((e) => jsonEncode(e.toJson())).toList());
  }
}