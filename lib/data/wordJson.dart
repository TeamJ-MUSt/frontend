import 'dart:convert';

class Word {
  int id;
  String spell;
  String? enPro;
  String japPro;
  String classOfWord;
  List<String> meaning;
  List<String> involvedSongs;

  Word({
    required this.id,
    required this.spell,
    this.enPro,
    required this.japPro,
    required this.classOfWord,
    required this.meaning,
    required this.involvedSongs,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    List<String> involvedSongs = List<String>.from(json['involvedSongs']);
    if (involvedSongs.length > 4) {
      involvedSongs = involvedSongs.sublist(0, 4);
    }

    return Word(
      id: json['id'],
      spell: json['spell'],
      enPro: json['enPro'],
      japPro: json['japPro'],
      classOfWord: json['classOfWord'],
      meaning: List<String>.from(json['meaning']),
      involvedSongs: involvedSongs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'spell': spell,
    'enPro': enPro,
    'japPro': japPro,
    'classOfWord': classOfWord,
    'meaning': List<dynamic>.from(meaning.map((x) => x)),
    'involvedSongs': List<dynamic>.from(involvedSongs.map((x) => x)),
  };
}

class APIWordParser {
  static List<Word> parseApiWordList(String jsonString) {
    final parsedJson = json.decode(jsonString);
    if (parsedJson['success'] == true) {
      final wordsList = parsedJson['words'] as List<dynamic>;
      return wordsList.map<Word>((json) => Word.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load words: API returned success=false');
    }
  }
}