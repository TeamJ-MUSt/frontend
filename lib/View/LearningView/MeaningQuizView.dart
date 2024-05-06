import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/LearningView/QuizEndView.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../../data/quizJson.dart';

class MeaningQuizView extends StatefulWidget {
  const MeaningQuizView({super.key});

  @override
  State<MeaningQuizView> createState() => _MeaningQuizViewState();
}

class _MeaningQuizViewState extends State<MeaningQuizView> {

  List<MeanQuiz> quizzes = []; //퀴즈 리스트
  int currentQuizIndex = 0; //현재 퀴즈 번호
  late String question; //문제
  late List<String> options; // 보기
  late String read; // 후리가나
  late int correctIndex; //정답
  late int selectedIndex; //고른인덱스
  String resultMessage = ''; //결과멘트
  String submitMent = '';  // 제출멘트
  late Color submitButtonColor; //선택버튼색
  int correctCnt = 0;
  bool end = false; //마지막

  @override
  void initState() {
    super.initState();
    question = '질문을 불러오는 중...'; // 초기 질문 값 설정
    options = []; // 초기 옵션 리스트
    read = ''; // 초기 읽기 값
    correctIndex = 0; // 초기 정답 인덱스
    selectedIndex = -1; // 초기 선택 인덱스
    submitButtonColor = myStyle.basicGray; // 초기 버튼 색상
    loadQuizData(); // 퀴즈 데이터 로드
  }
  void loadQuizData() async {
    try {
      // String jsonString = await notAPIMeanQuizData();
      quizzes = await notAPIMeanQuizData();  // 클래스 레벨의 quizzes를 직접 업데이트

      print("Loaded ${quizzes.length} quizzes."); // 로드된 퀴즈의 수 로깅

      if (quizzes.isNotEmpty) {
        updateQuizDisplay(0); // 첫 번째 퀴즈로 시작
      } else {
        print('Quiz data is empty');
      }
    } catch (e) {
      print('Error loading quiz data: $e');
    }
  }

  void updateQuizDisplay(int index) {
    if (quizzes.isNotEmpty) {  // 리스트가 비어 있지 않은지 확인
      setState(() {
        currentQuizIndex = index;
        question = quizzes[index].question;
        options = quizzes[index].options;
        read = quizzes[index].read;
        correctIndex = quizzes[index].options.indexOf(quizzes[index].answer);
        selectedIndex = -1;
        resultMessage = '';
        submitMent = "제출하기";
        submitButtonColor = myStyle.basicGray;
      });
    } else {
      print('Quiz data is empty');  // 로그를 남기거나 사용자에게 알림
    }
  }

  void submitAnswer() {
    if (selectedIndex == -1 || resultMessage.isNotEmpty) {
      // Avoid multiple submissions or no selection
      return;
    }

    setState(() {
      if (selectedIndex == correctIndex) {
        resultMessage = '정답입니다!';
        submitButtonColor = myStyle.pointColor;
        correctCnt+=1;
      } else {
        resultMessage = '오답입니다. 정답: ${quizzes[currentQuizIndex].answer}';
        submitButtonColor = myStyle.mainColor; // Assuming you have a color set for errors
      }

      // Always allow moving to the next question after a submission
      if (currentQuizIndex < quizzes.length - 1) {
        submitMent = "다음으로";
      } else {
        submitMent = "퀴즈 끝";
        end = true; // It's the last quiz
      }
    });
  }




  Widget optionButton(String option, int index) {
    return InkWell(
      onTap: end ? () {} : () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: selectedIndex == index ? myStyle.mainColor : Colors.white,
          border: Border.all(color: myStyle.mainColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            option,
            style: selectedIndex == index
                ? myStyle.textTheme.headlineMedium
                : myStyle.textTheme.labelMedium,
            // style: TextStyle(fontSize: 18.sp, color: selectedIndex == index ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "의미 퀴즈",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: quizzes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : buildQuizBody(),
    );
  }

  Widget buildQuizBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
      child: Column(
        children: [
          Text(
            '$currentQuizIndex'+'/'+ quizzes.length.toString(),
            style: myStyle.textTheme.bodyMedium,
          ),
          Expanded(
            flex: 2,
            child: Center(
              // color: myStyle.mainColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    question,
                    style: myStyle.textTheme.titleLarge,
                  ),
                  Text(
                    read,
                    style: myStyle.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text(resultMessage ?? '',
                      style: myStyle.textTheme.bodyMedium),
                ),
                ...options
                    .asMap()
                    .entries
                    .map((entry) {
                  int idx = entry.key;
                  String val = entry.value;
                  return Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                    child: optionButton(val, idx),
                  );
                }).toList(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 3.h, horizontal: 20.w),
                  child: InkWell(
                    onTap: () {
                      if (submitMent == "다음으로" || submitMent == "퀴즈 끝") {
                        if (currentQuizIndex < quizzes.length - 1) {
                          updateQuizDisplay(currentQuizIndex + 1); // Move to the next question
                        } else {
                          Get.offAll(()=>QuizEndView(correctCnt: correctCnt,));
                        }
                      } else {
                        submitAnswer();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: submitButtonColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          submitMent, style: myStyle.textTheme.headlineMedium,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}