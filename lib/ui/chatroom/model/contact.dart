import 'package:cloud_firestore/cloud_firestore.dart';

class ContactHome{

  String uid;
  Timestamp addedon;
  String type;
  String name;
  String photo;
  String text;
  int count;
  var block;

  ContactHome({
    this.uid,
    this.addedon,
    this.type,
    this.name,
    this.photo,
    this.text,
    this.count,
    this.block
});

  Map toMap(ContactHome contact){
    var data = Map<String, dynamic>();
    data["contact_id"] = contact.uid;
    data["added_on"] = contact.addedon;
    data["type"] = contact.type;
    data["name"] = contact.name;
    data["photo"] = contact.photo;
    data["text"] = contact.text;
    data["count"] = contact.count;
    data["block"] = contact.block;
    return data;
  }

  ContactHome.fromMap(Map<String, dynamic> mapData){
      this.uid = mapData["contact_id"];
      this.addedon = mapData["added_on"];
      this.type = mapData["type"];
      this.name = mapData["name"];
      this.text = mapData["text"];
      this.photo = mapData["photo"];
      this.count = mapData["count"];
      this.block = mapData["block"];
  }

}