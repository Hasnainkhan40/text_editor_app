// main.dart
import 'package:flutter/material.dart';
import 'package:text_editor_app/view/TextEditorScreen%20.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TextEditorScreen(),
    );
  }
}
