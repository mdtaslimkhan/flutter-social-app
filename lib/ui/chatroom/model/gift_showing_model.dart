class GiftShowingModel {

  String fromId;
  String fromName;
  String fromPhoto;
  String toId;
  String toName;
  String toPhoto;
  String diamond;
  String video;
  String image;

  GiftShowingModel({
    this.fromId, this.fromName, this.fromPhoto,
    this.toId, this.toName, this.toPhoto, this.diamond,
    this.video, this.image});


  GiftShowingModel.fromMap( Map<String, dynamic> gsm){
    this.fromId = gsm["fromId"];
    this.fromName = gsm["fromName"];
    this.fromPhoto = gsm["fromPhoto"];
    this.toId = gsm["toId"];
    this.toName = gsm["toName"];
    this.toPhoto = gsm["toPhoto"];
    this.diamond = gsm["diamond"];
    this.video = gsm["video"];
    this.image = gsm["image"];
  }


}