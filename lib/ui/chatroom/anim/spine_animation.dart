import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:spine_flutter/spine_flutter.dart';
import 'package:path_provider/path_provider.dart';
class SpineAnimation{
  static const String pathPrefix = 'assets/anim/';
  String _filePath;

  Set<String> animations;
  SkeletonAnimation skeleton;
 // File _animFile = File();
  String _rootPath;
  String _folderPath = "/app_flutter/flutter_assets/";

  Future<bool> load({String name, String path}) async {
    print(path);
    print("document root path");
    _rootPath = path + _folderPath;
    animations = await loadAnimations(name: name);
    skeleton = await loadSkeleton(name: name);
    return true;
  }

  Future<Set<String>> loadAnimations({String name}) async {
    final String skeletonFile = '$name.json';
    final String s = await rootBundle.loadString('$pathPrefix$name/$skeletonFile');
  //  final File _file = File('$_rootPath$name/$skeletonFile');
  //  final String s = await _file.readAsString();
    print('read documnet herer ==============================================================>>>>>>>>>>>');
    print(s);
    final Map<String, dynamic> data = json.decode(s);

    return ((data['animations'] ?? <String, dynamic>{}) as Map<String, dynamic>)
        .keys
        .toSet();
  }

  Future<SkeletonAnimation> loadSkeleton({String name}) async => SkeletonAnimation.createWithFiles(name, pathBase: pathPrefix);

}