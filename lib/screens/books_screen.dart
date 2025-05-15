import 'package:bookfan/screens/books_detail.dart';
import 'package:bookfan/screens/favourite_screen.dart';
import 'package:bookfan/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookfan/database/book.dart'; // Adjust the path accordingly
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookScreen extends StatefulWidget {
  final List<Book> books;

  BookScreen({required this.books});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<Book> favoriteBooks = [];

  Future<void> addFavoriteBook(Book book) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/add-favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'image': book.image,
        'rating': book.rating,
        'bookcontent': book.bookcontent,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book added to favorites')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add book to favorites')),
      );
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardHeight = screenWidth * 1.5 / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  setLocale: (Locale) {},
                  userName: '',
                ),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteBookScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1 / 1.8,
          ),
          itemCount: widget.books.length,
          itemBuilder: (context, index) {
            final book = widget.books[index];

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Option'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Detail'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailScreen(book: book),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Add to Favorite List'),
                            onTap: () {
                              addFavoriteBook(book);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 4.0,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Container(
                        height: cardHeight * 0.6,
                        child: Image.network(
                          book.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            book.author,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 14, color: Colors.yellow[700]),
                              SizedBox(width: 4),
                              Text(book.rating.toString(),
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
