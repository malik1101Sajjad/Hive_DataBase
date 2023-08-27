import 'package:hive_database/model_hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static Box<Student> getData() {
    String tableName = 'student';
    return Hive.box<Student>(tableName);
  }
}
