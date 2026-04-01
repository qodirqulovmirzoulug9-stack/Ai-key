import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(home: AIChat(), debugShowCheckedModeBanner: false));

class AIChat extends StatefulWidget {
  const AIChat({super.key});
  @override
  _AIChatState createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final TextEditingController _controller = TextEditingController();
  String _res = "Savol bering...";
  final String key = "Gsk_WR9V9HvIRSf2E5lOITgJWGdyb3FYFs4koyp75qqZQULggRxJEXzy";

  Future<void> ask(String text) async {
    setState(() => _res = "Oylayapman...");
    final r = await http.post(Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $key'},
      body: jsonEncode({'model': 'mixtral-8x7b-32768', 'messages': [{'role': 'user', 'content': text}]}),
    );
    setState(() => _res = jsonDecode(r.body)['choices'][0]['message']['content']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groq AI IPA")),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(20), child: Text(_res)))),
        Padding(padding: const EdgeInsets.all(10), child: Row(children: [
          Expanded(child: TextField(controller: _controller)),
          IconButton(icon: const Icon(Icons.send), onPressed: () => ask(_controller.text)),
        ]))
      ]),
    );
  }
}
