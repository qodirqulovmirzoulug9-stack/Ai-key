import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: AIChat()));

class AIChat extends StatefulWidget {
  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _controller = TextEditingController();
  String _response = "Savol bering...";

  Future<void> askAI(String text) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer SIZNING_KEYINGIZ', // Bu yerga keyni qo'yasiz
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [{'role': 'user', 'content': text}]
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _response = jsonDecode(response.body)['choices'][0]['message']['content'];
      });
    } else {
      setState(() => _response = "Xato yuz berdi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chat IPA")),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(20), child: Text(_response)))),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: () => askAI(_controller.text)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
