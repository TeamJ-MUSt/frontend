import 'dart:convert';
import 'package:http/http.dart' as http;

// JSON 문자열을 List<SeqQuiz>로 변환하는 함수
List<SeqQuiz> SeqQuizFromJson(String str) {
  final jsonData = json.decode(str) as Map<String, dynamic>;
  final quizzes = jsonData['quizDtos'] as List<dynamic>;
  return quizzes.map((item) => SeqQuiz.fromJson(item as Map<String, dynamic>)).toList();
}

// List<SeqQuiz>를 JSON 문자열로 변환하는 함수
String SeqQuizToJson(List<SeqQuiz> data) => json.encode({
  "quizDtos": data.map((item) => item.toJson()).toList()
});

class SeqQuiz {
  final List<String> answers; // answers 필드는 리스트로 정의
  final List<String> choices;

  SeqQuiz({
    required this.answers,
    required this.choices,
  });

  factory SeqQuiz.fromJson(Map<String, dynamic> json) {
    return SeqQuiz(
      answers: List<String>.from(json['answers'] as List<dynamic>).map((s) => s.trim()).toList(), // answers를 리스트로 파싱
      choices: List<String>.from(json['choices'] as List<dynamic>).map((s) => s.trim()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "answers": answers,
    "choices": choices,
  };
}