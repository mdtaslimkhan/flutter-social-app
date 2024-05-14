
class Post {
  Post({
    this.id,
    this.userName,
    this.userPhoto,
    this.userId,
    this.title,
    this.subTitle,
    this.photo,
    this.description,
    this.comment,
    this.postType,
    this.category,
    this.tag,
    this.isActive,
    this.like,
    this.unlike,
    this.tComment,
    this.currentUserLike,
    this.isFollowing,
    this.createdAt,
    this.isLiked,
  });

  int id;
  dynamic userName;
  dynamic userPhoto;
  int userId;
  dynamic title;
  dynamic subTitle;
  dynamic photo;
  dynamic description;
  dynamic comment;
  dynamic postType;
  dynamic category;
  dynamic tag;
  dynamic isActive;
  int like;
  dynamic unlike;
  dynamic tComment;
  dynamic currentUserLike;
  dynamic isFollowing;
  dynamic createdAt;
  bool isLiked;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    userName: json["user_name"],
    userPhoto: json["user_photo"],
    userId: json["user_id"],
    title: json["title"],
    subTitle: json["sub_title"],
    photo: json["photo"],
    description: json["description"],
    comment: json["comment"],
    postType: json["post_type"],
    category: json["category"],
    tag: json["tag"],
    isActive: json["is_active"],
    like: json["like"],
    unlike: json["dislike"],
    tComment: json["tComment"],
    currentUserLike: json["currentUserLike"],
    isFollowing: json["isFollowing"],
    createdAt: json["created_at"],
    isLiked: json['isLiked'],
  );

}

isLikedCheck(int like){
  if(like == null)
    return false;
  if(like == 1)
    return true;
  else
    return false;
}