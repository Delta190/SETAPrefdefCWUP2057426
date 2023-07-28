// ignore_for_file: unused_import, file_names

import 'package:hive/hive.dart';
import 'database/user.dart';
import 'database/book.dart';
import 'database/borrow.dart';
import 'hiveInit.dart';

List<Book> searchBooks({
  String? title,
  String? author,
  String? genre,
  bool? availability,
}) {
  final booksBox = Hive.box<Book>('books');
  final List<Book> matchingBooks = [];

  for (var i = 0; i < booksBox.length; i++) {
    final book = booksBox.getAt(i);
    if (book != null) {
      final bool isTitleMatch = title != null &&
          book.title.toLowerCase().contains(title.toLowerCase());
      final bool isAuthorMatch = author != null &&
          book.author.toLowerCase().contains(author.toLowerCase());
      final bool isGenreMatch = genre != null &&
          book.genre.toLowerCase().contains(genre.toLowerCase());
      final bool availabilityStatusMatch = availability != false;

      if (isTitleMatch ||
          isAuthorMatch ||
          isGenreMatch ||
          availabilityStatusMatch) {
        matchingBooks.add(book);
      }
    }
  }

  return matchingBooks;
}
