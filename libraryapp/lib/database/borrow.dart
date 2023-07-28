import 'package:hive/hive.dart';

part 'borrow.g.dart';

@HiveType(typeId: 2)
class Borrow extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late int userId;

  @HiveField(2)
  late int bookId;

  @HiveField(3)
  late DateTime borrowDate;

  @HiveField(4)
  late DateTime returnDate;
}
