import 'dart:ffi' hide Size;
import 'dart:io';
import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:path/path.dart' as p;

typedef ResizeNative = Pointer<Utf8> Function(Pointer<Utf8> path, Int width, Int height, Pointer<Utf8> output);
typedef ResizeDart = Pointer<Utf8> Function(Pointer<Utf8> path, int width, int height, Pointer<Utf8> output);

typedef GetSizeNative = Pointer<Utf8> Function(Pointer<Utf8> path);
typedef GetSizeDart = Pointer<Utf8> Function(Pointer<Utf8> path);

class Handler extends GetxController {
  static String convertHandler(List<dynamic> args){
    final dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'core.dylib' : 'core.dll');
    final ResizeDart resize=dynamicLib
    .lookup<NativeFunction<ResizeNative>>('Resize')
    .asFunction();

    return resize(args[0], args[1], args[2], args[3]).toDartString();
  }

  static String getSizeHandler(List<dynamic> args){
    final dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'core.dylib' : 'core.dll');
    final GetSizeDart getSize=dynamicLib
    .lookup<NativeFunction<GetSizeNative>>('GetSize')
    .asFunction();

    return getSize(args[0]).toDartString();
  }

  Future<String> convert(String path, int width, int height, String output, String outputName) async {
    final String rlt=await compute(convertHandler, [path.toNativeUtf8(), width, height, p.join(output, outputName).toNativeUtf8()]);
    return rlt;
  }

  Future<Size> getSize(String path) async {
    final String rlt=await compute(getSizeHandler, [path.toNativeUtf8()]);
    final List<String> size=rlt.split('x');
    return Size(double.parse(size[0]), double.parse(size[1]));
  }
}