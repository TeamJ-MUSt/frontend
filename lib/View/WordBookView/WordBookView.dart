import 'package:flutter/material.dart';
import 'dart:typed_data';

import '../../data/api_service.dart';
import '../../data/json2.dart'; // Ensure this path is correct for Song model

class WordBookView extends StatefulWidget {
  @override
  _WordBookViewState createState() => _WordBookViewState();
}

class _WordBookViewState extends State<WordBookView> {
  List<Song> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch API Data Example'),
      ),
      body:Center(),
    );
  }
}
