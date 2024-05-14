class GroupModel{

  int id;
  int admin;
  String groupId;
  String name;
  String description;
  String announce;
  String photo;
  String cover;
  String about;
  String type;
  String isVerified;
  int level;
  String address;
  String isPublic;
  String tag;
  String language;
  String nickName;
  String location;
  String countryCode;
  String rules1;
  String rules2;
  String rules3;
  String rules4;
  int view;


  GroupModel({
    this.id,
    this.admin,
    this.groupId,
    this.name,
    this.description,
    this.announce,
    this.photo,
    this.cover,
    this.about,
    this.type,
    this.isVerified,
    this.level,
    this.address,
    this.isPublic,
    this.tag,
    this.language,
    this.nickName,
    this.location,
    this.countryCode,
    this.rules1,
    this.rules2,
    this.rules3,
    this.rules4,
    this.view
});

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
      id : json["id"],
      admin : json["admin"],
      groupId : json["group_id"],
      name : json["name"],
      description : json["description"],
      announce : json["announce"],
      photo : json["photo"],
      cover : json["cover"],
      about : json["about"],
      type : json["type"],
      isVerified : json["is_verified"],
      level : json["level"],
      address : json["address"],
      tag : json["tag"],
      language : json["language"],
      nickName : json["nick_name"],
      isPublic : json["isPublic"],
      rules1 : json["rules_1"],
      rules2 : json["rules_2"],
      rules3 : json["rules_3"],
      rules4 : json["rules_4"],
      location : json["location"],
      countryCode : json["country_code"],
      view : json["view"],
  );




}