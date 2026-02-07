import 'dart:ffi' hide Size;
import 'dart:io';
import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

typedef ResizeNative = Pointer<Utf8> Function(Pointer<Utf8> path, Int width, Int height, Pointer<Utf8> output, Int stretch);
typedef ResizeDart = Pointer<Utf8> Function(Pointer<Utf8> path, int width, int height, Pointer<Utf8> output, int stretch);

typedef GetSizeNative = Pointer<Utf8> Function(Pointer<Utf8> path);
typedef GetSizeDart = Pointer<Utf8> Function(Pointer<Utf8> path);

typedef ReadDir = Pointer<Utf8> Function(Pointer<Utf8> path);
typedef ReadDirDart = Pointer<Utf8> Function(Pointer<Utf8> path);

class Handler extends GetxController {
  static String convertHandler(List<dynamic> args){
    final dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'core.dylib' : 'core.dll');
    final ResizeDart resize=dynamicLib
    .lookup<NativeFunction<ResizeNative>>('Resize')
    .asFunction();

    return resize(args[0], args[1], args[2], args[3], args[4]).toDartString();
  }

  static String getSizeHandler(List<dynamic> args){
    final dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'core.dylib' : 'core.dll');
    final GetSizeDart getSize=dynamicLib
    .lookup<NativeFunction<GetSizeNative>>('GetSize')
    .asFunction();

    return getSize(args[0]).toDartString();
  }

  static String readDirHandler(List<dynamic> args){
    final dynamicLib=DynamicLibrary.open(Platform.isMacOS ? 'core.dylib' : 'core.dll');
    final ReadDirDart readDir=dynamicLib
    .lookup<NativeFunction<ReadDir>>('ReadDir')
    .asFunction();

    return readDir(args[0]).toDartString();
  }

  Future<String> convert(String path, int width, int height, String output, String outputName, bool stretch) async {
    final String rlt=await compute(convertHandler, [path.toNativeUtf8(), width, height, p.join(output, outputName).toNativeUtf8(), stretch ? 1 : 0]);
    return rlt;
  }

  Future<String> convertWithPath(String path, int width, int height, String output, bool stretch) async {
    final String rlt=await compute(convertHandler, [path.toNativeUtf8(), width, height, output.toNativeUtf8(), stretch ? 1 : 0]);
    return rlt;
  }

  Future<Size?> getSize(String path) async {
    try {
      final String rlt=await compute(getSizeHandler, [path.toNativeUtf8()]);
      final List<String> size=rlt.split('x');
      return Size(double.parse(size[0]), double.parse(size[1]));
    } catch (_) {
      return null;
    }
  }

  Future<String> readDir(String path) async {
    final String rlt=await compute(readDirHandler, [path.toNativeUtf8()]);
    return rlt;
  }
}