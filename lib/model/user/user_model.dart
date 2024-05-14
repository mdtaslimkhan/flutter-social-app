// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  Usermodel({
    this.id,
    this.name,
    this.number,
    this.photo,
  });

  int id;
  String name;
  String number;
  String photo;

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
    id: json["id"],
    name: json["name"],
    number: json["number"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "number": number,
    "photo": photo,
  };
}
