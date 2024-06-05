// To parse this JSON data, do
//
//     final word = wordFromJson(jsonString);

import 'dart:convert';

class SpecialData {
  final String word;
  final String reading;
  final String meaning;

  SpecialData({required this.word, required this.reading, required this.meaning});
  factory SpecialData.fromJson(Map<String, dynamic> json) {
    return SpecialData(
      word: json['word'],
      reading: json['reading'],
      meaning: json['meaning'],
    );
  }
}