// To parse this JSON data, do
//
//     final word = wordFromJson(jsonString);

import 'dart:convert';

List<Word> wordFromJson(String str) => List<Word>.from(json.decode(str).map((x) => Word.fromJson(x)));

String wordToJson(List<Word> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Word {
  int id;
  String spell;
  String enPro;
  String japPro;
  String classOfWord;
  List<String> meaning;
  List<String> involvedSongs;

  Word({
    required this.id,
    required this.spell,
    required this.enPro,
    required this.japPro,
    required this.classOfWord,
    required this.meaning,
    required this.involvedSongs,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    id: json["id"],
    spell: json["spell"],
    enPro: json["enPro"],
    japPro: json["japPro"],
    classOfWord: json["classOfWord"],
    meaning: List<String>.from(json["meaning"].map((x) => x)),
    involvedSongs: List<String>.from(json["involvedSongs"].map((x) => x)),
  );

  static List<Word> parseUserList(String jsonString) {

    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Word>((json) => Word.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "spell": spell,
    "enPro": enPro,
    "japPro": japPro,
    "classOfWord": classOfWord,
    "meaning": List<dynamic>.from(meaning.map((x) => x)),
    "involvedSongs": List<dynamic>.from(involvedSongs.map((x) => x)),
  };
}
