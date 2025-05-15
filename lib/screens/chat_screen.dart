import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // List of messages

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Capture the user's message and clear the input field
    final userMessage = _controller.text;
    setState(() {
      _messages.add({"user": userMessage});
      _controller.clear();
    });

    try {
      // Send the message to the Node.js server and await the response
      final aiReply = await _getAIResponse(userMessage);

      // Add the AI's reply to the chat
      setState(() {
        _messages.add({"ai": aiReply});
      });
    } catch (error) {
      // Handle errors and show an error message in the chat
      setState(() {
        _messages.add({"ai": "Error fetching response. Please try again."});
      });
    }
  }

  Future<String> _getAIResponse(String message) async {
    // Replace with the appropriate URL for your server
    const url = 'http://localhost:3000/chat';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["reply"] ?? "No response from AI.";
    } else {
      throw Exception("Failed to fetch AI response: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Display messages in a ListView
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.containsKey("user");

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      isUser ? message["user"]! : message["ai"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
