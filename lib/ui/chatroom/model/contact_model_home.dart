import 'package:hive/hive.dart';

part 'contact_model_home.g.dart';

@HiveType(typeId: 0)
class ContactModelHome{

  @HiveField(0)
  String uid;

  @HiveField(1)
  String addedon;

  @HiveField(2)
  String type;

  ContactModelHome({
    this.uid,
    this.addedon,
    this.type,
});



}