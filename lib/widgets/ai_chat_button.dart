import 'package:flutter/material.dart';
import 'package:bookfan/screens/chat_screen.dart';

class AIChatButton extends StatelessWidget {
  const AIChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to the chat screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat_bubble_outline),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
