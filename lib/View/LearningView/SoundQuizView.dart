import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:must/data/ReadingQuizParsing.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';

class SoundQuizView extends StatefulWidget {
  const SoundQuizView({super.key});

  @override
  State<SoundQuizView> createState() => _SoundQuizViewState();
}

class _SoundQuizViewState extends State<SoundQuizView> {
  List<ReadQuiz> quizzes = [];
  int currentQuizIndex = 0;

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  void loadQuizData() async {
    // 가정: quizJsonString은 API 호출 또는 로컬 파일로부터 받은 JSON 문자열입니다.
    quizzes = await fetchReadQuizData();
    if (quizzes.isNotEmpty) {
      quizzes.forEach((quiz) {
        // answers를 choices에 추가하고 랜덤으로 섞습니다.
        quiz.choices.add(quiz.answers[0]);
        quiz.choices.shuffle(Random());
      });
      updateQuizDisplay(0); // 첫 번째 퀴즈로 시작
    } else {
      print('Quiz data is empty');
    }
  }

  void updateQuizDisplay(int index) {
    if (index < quizzes.length) {
      setState(() {
        currentQuizIndex = index;
      });
    }
  }

  Widget buildQuizBody() {
    if (quizzes.isEmpty) return Center(child: CircularProgressIndicator());
    ReadQuiz currentQuiz = quizzes[currentQuizIndex];
    return Column(
      children: [
        Text(currentQuiz.word, style: TextStyle(fontSize: 24)),
        ...currentQuiz.choices.map((choice) => ListTile(
          title: Text(choice),
          onTap: () => checkAnswer(choice, currentQuiz.answers),
        )).toList(),
      ],
    );
  }

  void checkAnswer(String selectedAnswer, List<String> correctAnswers) {
    if (correctAnswers.contains(selectedAnswer)) {
      print("정답입니다!");
    } else {
      print("오답입니다. 정답은 ${correctAnswers.join(', ')}입니다.");
    }
    if (currentQuizIndex < quizzes.length - 1) {
      updateQuizDisplay(currentQuizIndex + 1);
    } else {
      print("퀴즈가 끝났습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("발음 퀴즈"),
      ),
      body: buildQuizBody(),
    );
  }
}
