class ActiveMembers {
  String userId;
  String photo;

  ActiveMembers({this.userId, this.photo});

  factory ActiveMembers.fromRTDB(Map<String, dynamic> data ){
    return ActiveMembers(
      userId: data["userId"],
      photo: data["photo"],
    );
  }

}