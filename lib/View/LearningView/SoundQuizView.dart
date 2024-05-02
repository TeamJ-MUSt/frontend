import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:must/data/soundQuizParsing.dart';
import 'package:must/style.dart' as myStyle;

class SoundQuizView extends StatefulWidget {
  const SoundQuizView({super.key});

  @override
  State<SoundQuizView> createState() => _SoundQuizViewState();
}

class _SoundQuizViewState extends State<SoundQuizView> {
  // Now a list to hold multiple selections
  final String question = "僕ら";
  final String meaning = "우리";
  final String answer = "ぼく";
  late int answerLength = answer.length;
  var selectedOptions = [];
  final List<String> options = ["ぼ", "う", "ね", "ね", "ほ", "く"];
  String submitAnswer = '';

  void toggleOption(int index) {
    setState(() {
      if (selectedOptions.contains(index)) {
        selectedOptions.remove(index);
      } else {
        selectedOptions.add(index);
      }
      submitAnswer = selectedOptions.map((idx) {
        return options[idx];
      }).join();
    });
  }

  Widget optionButton(int index) {
    bool isSelected = selectedOptions.contains(index);
    return GestureDetector(
      onTap: () {
        toggleOption(index);
      },
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected ? myStyle.mainColor : Colors.white,
          border: Border.all(
            color: myStyle.mainColor,
            width: 2.0.w,
          ),
          borderRadius: BorderRadius.circular(8.0.r),
        ),
        child: Center(
          child: Text(
            options[index], // Directly use index to fetch the string
            style: TextStyle(
              fontSize: 22.0.sp,
              color: isSelected ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget quiz(QuizItem quiz){
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(submitAnswer),
              Text(
                quiz.question,
                style: myStyle.textTheme.titleLarge,
              ),
              Text(
                quiz.meaning,
                style: myStyle.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            itemCount: quiz.options.length,
            itemBuilder: (BuildContext context, int index) {
              return optionButton(index);
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: (){
              String result;
              submitAnswer == quiz.answer ? result='정답' : result ='오답';
              print(result);
            },
            child: Container(
              alignment: Alignment.center,
              // height: 35.h,
              decoration: BoxDecoration(
                color: submitAnswer == '' ? myStyle.basicGray : myStyle.mainColor,
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              child: Text(
                '스킵하기',
                style: myStyle.textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    List<QuizItem> quizItems = QuizItem.parseSoundQuizList(quizData as String);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "발음 퀴즈",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: Column(
          children: [
            Text(
              '2/30',
              style: myStyle.textTheme.bodyMedium,
            ),
            quiz(quizItems[0])
          ],
        ),
      ),
    );
  }
}
