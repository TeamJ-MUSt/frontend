import 'dart:convert';

List<SeqQuiz2> SeqQuizFromJson2(String str) {
  final jsonData = json.decode(str);
  final quizzes = jsonData['quizDtos'] as List;
  return quizzes.map((x) => SeqQuiz2.fromJson(x)).toList();
}
// Serialize a list of MeanQuiz objects back to a JSON string
String SeqQuizToJson(List<SeqQuiz2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeqQuiz2 {
  final String meaning;
  final List<String> options;
  final String answer;

  SeqQuiz2({
    required this.meaning,
    required this.options,
    required this.answer,
  });

  factory SeqQuiz2.fromJson(Map<String, dynamic> json) {
    return SeqQuiz2(
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
