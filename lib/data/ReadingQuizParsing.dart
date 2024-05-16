import 'dart:convert';

List<ReadQuiz> readQuizFromJson(String str) {
  final jsonData = json.decode(str);
  final quizzes = jsonData['quizDtos'] as List;
  return quizzes.map((x) => ReadQuiz.fromJson(x)).toList();
}
// Serialize a list of MeanQuiz objects back to a JSON string
String readQuizToJson(List<ReadQuiz> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReadQuiz {
  final String word;
  final List<String> answers;
  final List<String> choices;

  ReadQuiz({
    required this.word,
    required this.answers,
    required this.choices,
  });

  factory ReadQuiz.fromJson(Map<String, dynamic> json) {
    return ReadQuiz(
      word: json['word'],
      answers: List<String>.from(json['answers']),
      choices: List<String>.from(json['choices']),
    );
  }

  // Convert a MeanQuiz object to a JSON map
  Map<String, dynamic> toJson() =>
      {
        "word": word,
        "answers": answers,
        "choices": choices,
      };
}

