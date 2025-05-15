import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookfan/database/book.dart'; // Adjust the path accordingly
import 'package:bookfan/screens/read_screen.dart';

class FavoriteBookScreen extends StatefulWidget {
  @override
  _FavoriteBookScreenState createState() => _FavoriteBookScreenState();
}

class _FavoriteBookScreenState extends State<FavoriteBookScreen> {
  List<Book> favoriteBooks = [];

  Future<void> fetchFavoriteBooks() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/favorite-books'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        favoriteBooks = data
            .map((json) => Book(
                  id: json['id'],
                  title: json['title'],
                  author: json['author'],
                  image: json['image'],
                  rating: json['rating'],
                  bookcontent: json['bookcontent'],
                ))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch favorite books')),
      );
    }
  }

  Future<void> deleteFavoriteBook(String id) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/delete-favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        favoriteBooks.removeWhere((book) => book.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book removed from favorites')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove book from favorites')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Books'),
      ),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('No favorite books yet.'))
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
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
                                title: Text('Read Book'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReadScreen(book: book),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text('Remove from Favorite List'),
                                onTap: () {
                                  deleteFavoriteBook(book.id);
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      leading: Image.network(book.image,
                          fit: BoxFit.cover, width: 50, height: 70),
                      title: Text(book.title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('by ${book.author}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.yellow[700]),
                          SizedBox(width: 4),
                          Text(book.rating.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
