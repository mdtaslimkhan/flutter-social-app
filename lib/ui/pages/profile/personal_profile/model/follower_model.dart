class Follow{

  int follower;
  int following;
  int diamond;
  int gems;
  int level;
  int ratings;

  Follow({this.follower, this.following,this.diamond,this.gems, this.level,this.ratings});

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
    follower: json['follower'],
    following: json['following'],
    diamond: json['diamond'],
    gems: json['gems'],
    ratings: json['ratings'],
    level: json['level'],
  );

  Map<String,dynamic> toJson() => {
    "follower" : follower,
    "following" : following,
    "diamond" : diamond,
    "gems" : gems,
    "ratings" : ratings,
    "level" : level,
  };

}