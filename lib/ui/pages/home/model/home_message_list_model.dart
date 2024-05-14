
import 'package:hive/hive.dart';

part 'home_message_list_model.g.dart';

@HiveType(typeId: 0)
class HomeMessageList {

  @HiveField (0)
  String message;

  @HiveField (1)
  String time;

  @HiveField (2)
  String id;

  @HiveField (3)
  String name;

  @HiveField (4)
  String photo;

  @HiveField (5)
  String contactId;

  @HiveField (6)
  String type;

  HomeMessageList({this.message, this.time, this.id, this.name, this.photo, this.contactId, this.type});

}