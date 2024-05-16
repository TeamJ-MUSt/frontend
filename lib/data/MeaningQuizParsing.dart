import 'dart:convert';

// Main function to parse JSON string into a list of MeanQuiz objects
List<MeanQuiz> meanQuizFromJson(String str) {
  final jsonData = json.decode(str);
  final quizzes = jsonData['quizDtos'] as List;
  return quizzes.map((x) => MeanQuiz.fromJson(x)).toList();
}

// Serialize a list of MeanQuiz objects back to a JSON string
String meanQuizToJson(List<MeanQuiz> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeanQuiz {
  String word;
  List<String> answers;
  List<String> choices;

  MeanQuiz({
    required this.word,
    required this.answers,
    required this.choices,
  });

  // Factory constructor to create a MeanQuiz object from JSON map
  factory MeanQuiz.fromJson(Map<String, dynamic> json) => MeanQuiz(
    word: json['word'],
    answers: List<String>.from(json['answers']),
    choices: List<String>.from(json['choices']),
  );

  // Convert a MeanQuiz object to a JSON map
  Map<String, dynamic> toJson() => {
    "word": word,
    "answers": answers,
    "choices": choices,
  };
}