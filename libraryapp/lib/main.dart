// ignore_for_file: unnecessary_import, unused_import, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/user.dart';
import 'database/book.dart';
import 'database/borrow.dart';
import 'hiveInit.dart';
import 'dbInteraction.dart';

void main() async {
  loadDB();
  printAllBooks();
  //runApp(MyApp());
}

void printAllBooks() async {
  await Hive.openBox<Book>('book');
  final List<Book> allBooks = BookDB.bookBox.values.toList();
  if (allBooks.isEmpty) {
    print("No books found.");
  } else {
    print("Printing all books:");
    for (final book in allBooks) {
      print("Title: ${book.title}");
      print("Author: ${book.author}");
      print("Genre: ${book.genre}");
      print("Availability: ${book.availabilityStatus}");
      print("Synopsis: ${book.synopsis}");
      print("Publication Date: ${book.publicationDate}");
      print("ISBN: ${book.isbn}");
      print("Cover Image URL: ${book.coverImageURL}");
      print("--------------------------");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      home: HomePage(),
    );
  }
}

String borrowBook(
    {required int bookId,
    required int userId,
    required Duration duration,
    required DateTime returnDate}) {
  User? user = UserDB.getUserById(userId);
  Book? book = BookDB.getBookById(bookId);

  // Check if both User and Book exist
  if (user == null) {
    return 'User not found.';
  }

  if (book == null) {
    return 'Book not found.';
  }

  // Check if the book is already borrowed
  if (!book.availabilityStatus) {
    return 'Book is already borrowed.';
  }

  // Create a new Borrow instance and set the properties
  Borrow borrow = Borrow();
  borrow.userId = user.id;
  borrow.bookId = book.id;
  borrow.borrowDate = DateTime.now();
  borrow.returnDate = returnDate.add(duration);

  // Add the new Borrow instance to the Hive box
  BorrowDB.addBorrow(borrow);

  // Update the book's availability status to false (borrowed)
  book.availabilityStatus = false;
  BookDB.updateBook(book);

  // Return the due date details as a string upon successful borrowing
  return 'Book borrowed successfully. Due date: ${borrow.returnDate}';
}

String returnBook({required int bookId, required int userId}) {
  User? user = UserDB.getUserById(userId);
  Book? book = BookDB.getBookById(bookId);

  // Check if both User and Book exist
  if (user == null) {
    return 'User not found.';
  }

  if (book == null) {
    return 'Book not found.';
  }

  // Check if the book is already available (not borrowed)
  if (book.availabilityStatus) {
    return 'Book is already available.';
  }

  // Update the book's availability status to true (returned)
  book.availabilityStatus = true;
  BookDB.updateBook(book);

  // Delete the borrow record from the Hive box
  BorrowDB.deleteBorrow(bookId);

  // Return the success message
  return 'Book returned successfully.';
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Portal App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the OnLibrary!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // If the search icon is tapped, navigate to the SearchPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _title;
  String? _author;
  String? _genre;
  List<Book> _matchingBooks = [];

  void _onSearchButtonPressed() {
    _matchingBooks = searchBooks(
      title: _title,
      author: _author,
      genre: _genre,
    );

    setState(() {
      print('Search results updated: ${_matchingBooks.length} books found.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter book title...',
                    ),
                    onChanged: (value) {
                      _title = value.trim();
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter author...',
                    ),
                    onChanged: (value) {
                      _author = value.trim();
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter genre...',
                    ),
                    onChanged: (value) {
                      _genre = value.trim();
                    },
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _onSearchButtonPressed,
            child: Text('Search'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _matchingBooks.length,
              itemBuilder: (context, index) {
                final book = _matchingBooks[index];
                return GestureDetector(
                  onTap: () {
                    // Handle book click here
                  },
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                    //leading: Icon(Icons.book),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
