class Gift{

  Gift({
  this.title,
  this.description,
  this.img,
  this.video,
  this.date,
  this.diamond,
  });

  String title;
  String description;
  String img;
  String video;
  String date;
  String diamond;

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
  title: json["title"],
  description: json["description"],
  img: json["img"],
  video: json["video"],
  date: json["date"],
  diamond: json["diamond"],
  );

  Map<String, dynamic> toJson() => {
  "title": title,
  "description": description,
  "img": img,
  "video": video,
  "date": date,
  "diamond": diamond,
  };


}