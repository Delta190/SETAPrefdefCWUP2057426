// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_import, duplicate_import, unused_local_variable

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/user.dart';
import 'database/book.dart';
import 'database/borrow.dart';

Future<void> loadDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<Book>(BookAdapter());
  Hive.registerAdapter<Borrow>(BorrowAdapter());

  var userBox = await Hive.openBox<User>('user');
  var bookBox = await Hive.openBox<Book>('book');
  var borrowBox = await Hive.openBox<Borrow>('borrow');

  loadUsers(userBox);
  loadBooks(bookBox);
  loadBorrows(borrowBox);
}

void loadUsers(Box<User> usersBox) {
  final file = File('lib/database/DBuser.csv');
  final contents = file.readAsStringSync();

  final lines = contents.split('\n');

  for (var i = 1; i < lines.length; i++) {
    final fields = lines[i].split(',');

    final user = User()
      ..username = fields[0]
      ..email = fields[1]
      ..password = fields[2];

    usersBox.add(user);
  }
}

void loadBooks(Box<Book> booksBox) {
  final file = File('lib/database/DBbook.csv');
  final contents = file.readAsStringSync();

  final lines = contents.split('\n');

  for (var i = 1; i < lines.length; i++) {
    final fields = lines[i].split(',');

    final book = Book()
      ..title = fields[0]
      ..author = fields[1]
      ..genre = fields[2]
      ..availabilityStatus = fields[3].toLowerCase() == 'true'
      ..synopsis = fields[4]
      ..publicationDate = DateTime.parse(fields[5])
      ..isbn = fields[6]
      ..coverImageURL = fields[7];

    booksBox.add(book);
  }
}

void loadBorrows(Box<Borrow> borrowsBox) {
  final file = File('lib/database/DBborrow.csv');
  final contents = file.readAsStringSync();

  final lines = contents.split('\n');

  for (var i = 1; i < lines.length; i++) {
    final fields = lines[i].split(',');

    final borrow = Borrow()
      ..userId = int.parse(fields[0])
      ..bookId = int.parse(fields[1])
      ..borrowDate = DateTime.parse(fields[2])
      ..returnDate = DateTime.parse(fields[3]);

    borrowsBox.add(borrow);
  }
}

class UserDB {
  static Box<User> userBox = Hive.box<User>('users');

  static User? getUserById(int id) {
    return userBox.get(id);
  }

  static void addUser(User user) {
    userBox.add(user);
  }

  static void updateUser(User updatedUser) {
    userBox.put(updatedUser.id, updatedUser);
  }

  static void deleteUser(int id) {
    userBox.delete(id);
  }
}

class BookDB {
  static Box<Book> bookBox = Hive.box<Book>('books');

  static Book? getBookById(int id) =>
      bookBox.values.firstWhere((book) => book.id == id);

  static void addBook(Book book) {
    bookBox.add(book);
  }

  static void updateBook(Book updatedBook) {
    bookBox.put(updatedBook.id, updatedBook);
  }

  static void deleteBook(int id) {
    bookBox.delete(id);
  }
}

// CRUD functions for Borrow entity
class BorrowDB {
  static Box<Borrow> borrowBox = Hive.box<Borrow>('borrows');

  static void addBorrow(Borrow borrow) {
    borrowBox.add(borrow);
  }

  static Borrow? getBorrowById(int id) {
    return borrowBox.values.firstWhere((borrow) => borrow.id == id);
  }

  static List<Borrow> getAllBorrows() {
    return borrowBox.values.toList();
  }

  static void updateBorrow(Borrow updatedBorrow) {
    borrowBox.put(updatedBorrow.id, updatedBorrow);
  }

  static void deleteBorrow(int id) {
    borrowBox.delete(id);
  }
}
