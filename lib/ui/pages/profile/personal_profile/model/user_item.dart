import 'package:chat_app/util/constants.dart';

class UserItem {
  UserItem({
    this.id,
    this.name,
    this.photo,
    this.date
  });

  int id;
  String name;
  String photo;
  String date;

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
    id: checkNullInt(json["id"]),
    name: checkNull(json["name"]),
    photo: json["photo"],
    date: checkNull(json["date"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "date": date
  };
}
