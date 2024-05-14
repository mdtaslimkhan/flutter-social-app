class Crown {
  Crown({
    this.title,
    this.description,
    this.img,
    this.video,
    this.date,
  });

  String title;
  String description;
  String img;
  String video;
  String date;

  factory Crown.fromJson(Map<String, dynamic> json) => Crown(
    title: json["title"],
    description: json["description"],
    img: json["img"],
    video: json["video"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "img": img,
    "video": video,
    "date": date,
  };
}
