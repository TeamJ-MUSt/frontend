// To parse this JSON data, do
//
//     final word = wordFromJson(jsonString);

import 'dart:convert';

List<Word> wordFromJson(String str) => List<Word>.from(json.decode(str).map((x) => Word.fromJson(x)));

String wordToJson(List<Word> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Word {
  String write;
  String read;
  String wordClass;
  String mean;
  List<String> include;

  Word({
    required this.write,
    required this.read,
    required this.wordClass,
    required this.mean,
    required this.include,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    write: json["write"],
    read: json["read"],
    wordClass: json["class"],
    mean: json["mean"],
    include: List<String>.from(json["include"].map((x) => x)),
  );

  static List<Word> parseUserList(String jsonString) {

    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Word>((json) => Word.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
    "write": write,
    "read": read,
    "class": wordClass,
    "mean": mean,
    "include": List<dynamic>.from(include.map((x) => x)),
  };
}
