
class GiftUserModel {
  GiftUserModel({
    this.userId,
    this.name,
    this.photo,
    this.nValue = false,

  });

  String userId;
  String name;
  String photo;
  bool nValue;

  factory GiftUserModel.fromJson(Map<String, dynamic> json) => GiftUserModel(
  userId: json["userId"],
  name: json["name"],
  photo: json["photo"],

  );

}
