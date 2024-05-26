import 'dart:convert';

List<SeqQuiz> SeqQuizFromJson(String str) {
  final jsonData = json.decode(str);
  final quizzes = jsonData['quizDtos'] as List;
  return quizzes.map((x) => SeqQuiz.fromJson(x)).toList();
}
// Serialize a list of MeanQuiz objects back to a JSON string
String SeqQuizToJson(List<SeqQuiz> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeqQuiz {
  final String meaning;
  final List<String> options;
  final String answer;

  SeqQuiz({
    required this.meaning,
    required this.options,
    required this.answer,
  });

  factory SeqQuiz.fromJson(Map<String, dynamic> json) {
    return SeqQuiz(
      meaning: json['meaning'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }

  // Convert a MeanQuiz object to a JSON map
  Map<String, dynamic> toJson() =>
      {
        "meaning": meaning,
        "options": options,
        "answer": answer,
      };
}

