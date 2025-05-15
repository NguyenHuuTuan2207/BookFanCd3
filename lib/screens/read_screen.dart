import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:bookfan/database/book.dart'; // Adjust the path accordingly
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert'; // For UTF-8 decoding
import 'package:http/http.dart' as http; // Import the http package
import 'package:flutter_tts/flutter_tts.dart'; // Import flutter_tts package

class ReadScreen extends StatefulWidget {
  final Book book;

  ReadScreen({required this.book});

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  String? fileContent; // Store the content of the text file
  String? localPath;
  String selectedText = ""; // Store the selected text
  late FlutterTts flutterTts; // Instance of the text-to-speech engine
  bool isReading = false; // Track if TTS is currently reading

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    loadTextFile();
  }

  Future<void> loadTextFile() async {
    if (kIsWeb) {
      print('Running on Web');
      final url =
          'http://localhost:3000/assets/text/${widget.book.bookcontent}';
      try {
        final response = await http.get(Uri.parse(url)); // Use http.get
        if (response.statusCode == 200) {
          setState(() {
            fileContent = response.body; // Assign the text content
          });
        } else {
          print('Error fetching text file: ${response.statusCode}');
        }
      } catch (e) {
        print('Error loading text file: $e');
      }
    } else {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/${widget.book.bookcontent}');
        if (await file.exists()) {
          final content = await file.readAsString();
          setState(() {
            fileContent = content; // Assign the text content
          });
        } else {
          print('Text file does not exist at: ${file.path}');
        }
      } catch (e) {
        print('Error loading text file: $e');
      }
    }
  }

  Future<void> speak() async {
    if (selectedText.isNotEmpty) {
      setState(() => isReading = true); // Update state to reading
      await flutterTts.speak(selectedText); // Speak the selected text
    } else {
      await flutterTts.speak("Please select some text to read aloud.");
    }
  }

  Future<void> stop() async {
    await flutterTts.stop(); // Stop the TTS
    setState(() => isReading = false); // Update state to stopped
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: fileContent != null
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(
                      fileContent!,
                      style: const TextStyle(fontSize: 16.0),
                      onSelectionChanged: (selection, cause) {
                        final start = selection.start;
                        final end = selection.end;
                        if (start >= 0 && end >= 0 && start != end) {
                          setState(() {
                            selectedText = fileContent!.substring(start, end);
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed:
                        isReading ? stop : speak, // Toggle between actions
                    child:
                        Icon(isReading ? Icons.stop : Icons.mic), // Toggle icon
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
