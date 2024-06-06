import 'dart:convert';

class SongWord {
  int id;
  String spell;
  String? enPro;
  String japPro;
  String classOfWord;
  List<String> meaning;
  List<String> involvedSongs;

  SongWord({
    required this.id,
    required this.spell,
    this.enPro,
    required this.japPro,
    required this.classOfWord,
    required this.meaning,
    required this.involvedSongs,
  });

  factory SongWord.fromJson(Map<String, dynamic> json) {
    List<String> involvedSongs = List<String>.from(json['involvedSongs']);
    if (involvedSongs.length > 4) {
      involvedSongs = involvedSongs.sublist(0, 4);
    }

    return SongWord(
      id: json['id'],
      spell: json['spell'],
      enPro: json['enPro'],
      japPro: json['japPro'],
      classOfWord: json['classOfWord'],
      meaning: List<String>.from(json['meaning']),
      involvedSongs: involvedSongs,
    );
  }
}

class WordParser {
  static List<SongWord> parseMusicWordList(String jsonString) {
    final List<dynamic> parsedJson = json.decode(jsonString);
    return parsedJson.map<SongWord>((json) => SongWord.fromJson(json as Map<String, dynamic>)).toList();
  }
}
