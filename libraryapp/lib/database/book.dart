import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Book extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String author;

  @HiveField(3)
  late String genre;

  @HiveField(4)
  late bool availabilityStatus;

  @HiveField(5)
  late String synopsis;

  @HiveField(6)
  late DateTime publicationDate;

  @HiveField(7)
  late String isbn;

  @HiveField(8)
  late String coverImageURL;
}
