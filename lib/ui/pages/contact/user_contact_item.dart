import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';

class UserContactItem{

  String contactName;
  Item number;
  Uint8List imageUrl;
  UserContactItem({this.contactName,this.number, this.imageUrl});

}