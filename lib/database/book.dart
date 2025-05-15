class Book {
  final String id;
  final String image;
  final String bookcontent;
  final String title;
  final String author;
  final double rating;

  Book({
    required this.id,
    required this.image,
    required this.title,
    required this.author,
    required this.rating,
    required this.bookcontent,
  });

  // fromJson method to convert a JSON map to a Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'], // Adjust the key to match your API response
      image: json['image_url'], // Adjust the key to match your API response
      title: json['title'],
      author: json['author'],
      rating: json['rating'].toDouble(),
      bookcontent: json['bookcontent'],
    );
  }

  // Optionally, a toJson method to convert the Book object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': image,
      'title': title,
      'author': author,
      'rating': rating,
      'bookcontent': bookcontent,
    };
  }
}
