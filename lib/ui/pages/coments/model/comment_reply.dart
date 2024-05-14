
class Reply{

  Reply({
    this.commentId,
    this.currentUserId,
    this.id,
    this.name,
    this.photos,
    this.userId,
    this.postId,
    this.comment,
    this.rtlike,
    this.risLiked,
    this.createdAt,
  });

  final int commentId;
  final int currentUserId;
  final int id;
  final String name;
  final String photos;
  final int userId;
  final int postId;
  final String comment;
  final int rtlike;
  final int risLiked;
  final String createdAt;

  factory Reply.fromJson(Map<String, dynamic> json) =>
      Reply(
        id: json["id"],
        name: json["name"],
        photos: json["photo"],
        userId: json["user_id"],
        postId: json["post_id"],
        comment: json["comment"],
        rtlike: json["rtlike"],
        risLiked: json["risLiked"],
        createdAt: json["created_at"],
      );
}