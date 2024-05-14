
import 'dart:io';
import 'dart:math';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class ImageUploadFunction{

  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final ImagePicker _picker = ImagePicker();

  Future<File> pickImage({@required ImageSource source}) async {
    XFile selectedImage = await _picker.pickImage(source: source, maxHeight: 1075, maxWidth: 1000);
   // return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final temDir = await getTemporaryDirectory();
    final path = temDir.path;
    int random = Random().nextInt(1000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    // Im.Image bResize = Im.copyResize(image, width: 300, height: 375);
    return new File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }











}