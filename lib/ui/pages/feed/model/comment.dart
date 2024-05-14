import '../../coments/model/comment_reply.dart';

class Comment{

  Comment({
    this.showBottomst,
    this.logedUserId,
    this.id,
    this.name,
    this.photo,
    this.userId,
    this.postId,
    this.comment,
    this.tlike,
    this.isLiked,
    this.reply,
    this.replyLastPage,
    this.createdAt,
  });

  final Function showBottomst;
  final int logedUserId;
  final int id;
  final String name;
  final String photo;
  final int userId;
  final int postId;
  final String comment;
  final int tlike;
  final int isLiked;
  final List<Reply> reply;
  final int replyLastPage;
  final String createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    userId: json["user_id"],
    postId: json["post_id"],
    comment: json["comment"],
    tlike: json["tlike"],
    isLiked: json["isLiked"],
    reply: List<Reply>.from(json["reply"].map((x) => Reply.fromJson(x))),
    replyLastPage: json["reply_last_page"],
    createdAt: json["created_at"],
  );

}