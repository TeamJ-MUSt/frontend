import 'dart:convert';

class QuizItem {
  final String question;
  final String meaning;
  final List<String> options;
  final String answer;

  QuizItem({
    required this.question,
    required this.meaning,
    required this.options,
    required this.answer,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      question: json['question'],
      meaning: json['meaning'],
      options: List<String>.from(json['options'] as List),
      answer: json['answer'],
    );
  }

  static List<QuizItem> parseSoundQuizList(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<QuizItem>((json) => QuizItem.fromJson(json)).toList();
  }
}

// Example function that might be in your codebase
QuizItem quizData(String str) => QuizItem.fromJson(json.decode(str));
