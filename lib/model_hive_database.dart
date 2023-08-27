import 'package:hive_flutter/adapters.dart';
part 'model_hive_database.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String imageUrl;
  Student({required this.name, required this.imageUrl});
}
