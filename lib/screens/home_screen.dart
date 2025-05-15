import 'package:bookfan/consttants.dart';
import 'package:bookfan/screens/details_screen.dart';
import 'package:bookfan/screens/user_screen.dart';
import 'package:bookfan/screens/books_screen.dart';
import 'package:bookfan/widgets/ai_chat_button.dart';
import 'package:bookfan/widgets/book_rating.dart';
import 'package:bookfan/widgets/reading_card_list.dart';
import 'package:bookfan/widgets/two_side_rounded_button.dart';
import 'package:bookfan/database/book.dart'; // Adjust the path accordingly
import 'package:bookfan/database/helper.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale; // Add a setLocale parameter
  final String userName; // Define the userName parameter

  HomeScreen(
      {required this.setLocale, required this.userName}); // Make it required

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Book>> _booksFuture; // Declare _booksFuture here

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize the _booksFuture with the fetchBooks method from DatabaseHelper
    _booksFuture = _loadBooks();
  }

  Future<List<Book>> _loadBooks() async {
    // Directly fetch the books from the database
    final books = await databaseHelper.fetchBooks(); // Adjust if necessary
    return books;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Home content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/main_page_bg.png"),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: size.height * .1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headlineMedium,
                            children: [
                              TextSpan(text: "What are you \nreading "),
                              TextSpan(
                                text: "today?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            ReadingListCard(
                              image: "assets/images/book-1.png",
                              title: "Crushing & Influence",
                              auth: "Gary Venchuk",
                              rating: 4.9,
                              pressDetails: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailsScreen();
                                    },
                                  ),
                                );
                              },
                              pressRead: () {},
                            ),
                            ReadingListCard(
                              image: "assets/images/book-2.png",
                              title: "Top Ten Business Hacks",
                              auth: "Herman Joel",
                              rating: 4.8,
                              pressRead: () {},
                              pressDetails: () {},
                            ),
                            SizedBox(width: 30),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                children: [
                                  TextSpan(text: "Best of the "),
                                  TextSpan(
                                    text: "day",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            bestOfTheDayCard(size, context),
                            RichText(
                              text: TextSpan(
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                children: [
                                  TextSpan(text: "Continue "),
                                  TextSpan(
                                    text: "reading...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(38.5),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 33,
                                    color: Color(0xFFD3D3D3).withOpacity(.84),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(38.5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Crushing & Influence",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Gary Venchuk",
                                                    style: TextStyle(
                                                      color: kLightBlackColor,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      "Chapter 7 of 10",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: kLightBlackColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/images/book-1.png",
                                              width: 55,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 7,
                                      width: size.width * .65,
                                      decoration: BoxDecoration(
                                        color: kProgressIndicator,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab 2: Books Screen
          FutureBuilder<List<Book>>(
            future: _booksFuture, // Fetch books from the database
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No books available"));
              } else {
                return BookScreen(
                    books: snapshot.data!); // Pass the fetched books list here
              }
            },
          ),

          // Tab 3: User Screen
          UserScreen(
            setLocale: widget.setLocale,
            userName: widget.userName, // Pass the setLocale function here
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(icon: Icon(Icons.home), text: "Home"),
          Tab(icon: Icon(Icons.book), text: "Books"),
          Tab(icon: Icon(Icons.person), text: "User"),
        ],
      ),
      floatingActionButton: const AIChatButton(), // Add the AI Chat Button here
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "New York Time Best For 11th March 2020",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    "How To Win \nFriends &  Influence",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Gary Venchuk",
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 4.9),
                        ),
                        Expanded(
                          child: Text(
                            "When the earth was flat and everyone wanted to win the game of the best and people….",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/book-3.png",
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Read",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
