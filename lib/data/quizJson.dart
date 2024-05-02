import 'dart:convert';

MeanQuiz meanQuizFromJson(String str) => MeanQuiz.fromJson(json.decode(str));

String meanQuizToJson(MeanQuiz data) => json.encode(data.toJson());


class MeanQuiz{
  String question;
  String read;
  List<String> options;
  String answer;

  MeanQuiz({
    required this.question,
    required this.read,
    required this.options,
    required this.answer,
});

  factory MeanQuiz.fromJson(Map<String, dynamic> json) => MeanQuiz(
    options: List<String>.from(json['options'] as List), // 안전한 캐스팅
    question: json['question'] as String,
    read: json['read'] as String,
    answer: json['answer'] as String,
  );

  static List<MeanQuiz> parseUserList(String jsonString) {

    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<MeanQuiz>((json) => MeanQuiz.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "read": read,
    "options": options,
    "answer": answer,
  };
}