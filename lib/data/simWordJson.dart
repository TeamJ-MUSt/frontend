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


  Map<String, dynamic> toJson() => {
    "spell": spell,
    "japPro": japPro,
    "classOfWord": classOfWord,
    "meaning": List<dynamic>.from(meaning.map((x) => x)),
  };

  static List<SimWord> parseSimWordList(String jsonString) {
    final parsedJson = json.decode(jsonString);
    if (parsedJson['success']==true) {
      final simWordsList = parsedJson['similarWordDtoList'] as List<dynamic>;
      return simWordsList.map<SimWord>((json)=>SimWord.fromJson(json as Map<String, dynamic>)).toList();
    }else {

      throw Exception('Failed to load words: API returned success=false');

    }
  }
}
