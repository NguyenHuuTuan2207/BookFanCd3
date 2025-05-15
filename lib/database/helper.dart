import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookfan/database/book.dart'; // Import your Book model

class DatabaseHelper {
  static const String _baseUrl = 'http://localhost:3000'; // The backend API URL

  // Fetch books from the backend API
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/books'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((bookData) => Book.fromJson(bookData)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }
}
