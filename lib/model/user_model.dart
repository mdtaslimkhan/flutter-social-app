
class UserModel {
  UserModel({
    this.id,
    this.fName,
    this.nName,
    this.number,
    this.crUserId,
    this.photo,
    this.cover,
    this.birth,
    this.gender,
    this.email,
    this.occupation,
    this.location,
    this.address,
    this.country,
    this.about,
    this.isActive,
    this.isVerified,
    this.level,
    this.rating,
    this.nValue = false,
    this.exist,
    this.showContact,
  });

  int id;
  String fName;
  String nName;
  String number;
  String crUserId;
  String photo;
  String cover;
  String birth;
  String gender;
  String email;
  String occupation;
  String location;
  String address;
  String country;
  String about;
  int isActive;
  String isVerified;
  String level;
  String rating;
  bool nValue;
  int exist;
  int showContact;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    fName: json["fName"],
    nName: json["nName"],
    number: json["number"],
    crUserId: json["cr_user_id"],
    photo: json["photo"],
    cover: json["cover"],
    birth: json["birth"],
    gender: json["gender"],
    email: json["email"],
    occupation: json["occupation"],
    location: json["location"],
    address: json["address"],
    country: json["country"],
    about: json["about"],
    isActive: json["is_active"],
    isVerified: json["is_verified"],
    level: json["level"],
    rating: json["rating"],
    exist: json["exist"],
    showContact: json["show_contact"],

  );

}
