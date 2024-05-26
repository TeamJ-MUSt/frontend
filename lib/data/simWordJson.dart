// To parse this JSON data, do
//
//     final word = wordFromJson(jsonString);

import 'dart:convert';

List<SimWord> simWordFromJson(String str) => List<SimWord>.from(json.decode(str).map((x) => SimWord.fromJson(x)));

String wordToJson(List<SimWord> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SimWord {
  String spell;
  String japPro;
  String classOfWord;
  List<String> meaning;

  SimWord({
    required this.spell,
    required this.japPro,
    required this.classOfWord,
    required this.meaning,
  });

  factory SimWord.fromJson(Map<String, dynamic> json) => SimWord(
    spell: json["spell"],
    japPro: json["japPro"],
    classOfWord: json["classOfWord"],
    meaning: List<String>.from(json["meaning"].map((x) => x)),
  );

  static List<SimWord> parseUserList(String jsonString) {

    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<SimWord>((json) => SimWord.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
    "spell": spell,
    "japPro": japPro,
    "classOfWord": classOfWord,
    "meaning": List<dynamic>.from(meaning.map((x) => x)),
  };
}
