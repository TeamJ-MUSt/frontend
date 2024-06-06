import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:must/View/LearningView/QuizEndView.dart';
import 'package:must/style.dart' as myStyle;
import 'dart:math';
import '../../data/api_service.dart';
import '../../data/MeaningQuizParsing.dart';

import 'package:http/http.dart' as http;

class MeaningQuizView extends StatefulWidget {
  MeaningQuizView({required this.songId, required this.setNum, super.key});

  final int songId;
  final int setNum;

  @override
  State<MeaningQuizView> createState() => _MeaningQuizViewState();
}

class _MeaningQuizViewState extends State<MeaningQuizView>
    with SingleTickerProviderStateMixin {
  List<MeanQuiz> quizzes = []; // 퀴즈 리스트
  int currentQuizIndex = 0; // 현재 퀴즈 번호
  late String question; // 문제
  late String answers; // 답
  late List<String> choices; // 보기
  late int correctIndex; // 정답
  late int selectedIndex; // 고른 인덱스
  String resultMessage = ''; // 결과 멘트
  String submitMent = ''; // 제출 멘트
  late Color submitButtonColor; // 선택 버튼 색상
  int correctCnt = 0;
  bool end = false; // 마지막

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    question = '질문을 불러오는 중...'; // 초기 질문 값 설정
    choices = []; // 초기 옵션 리스트
    correctIndex = 0; // 초기 정답 인덱스
    selectedIndex = -1; // 초기 선택 인덱스
    submitButtonColor = myStyle.basicGray; // 초기 버튼 색상
    // tts.setLanguage("ja-JP");
    // tts.setSpeechRate(0.4); // 음성 속도 설정
    // tts.setVolume(1.0); // 볼륨 설정
    // tts.setPitch(1.0); // 음조 설정
    loadQuizData(); // 퀴즈 데이터 로드

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadQuizData() async {
    await getQuiz(); // 퀴즈 데이터 로드
    setState(() {}); // 상태 업데이트
  }

  // 추후 삭제
  void skipToLastQuestion() {
    updateQuizDisplay(quizzes.length - 1);
  }

  Future<void> getQuiz() async {
    quizzes = await getMeanQuizSet(
        widget.setNum, widget.songId); // 클래스 레벨의 quizzes를 직접 업데이트
    print("Loaded ${quizzes.length} quizzes."); // 로드된 퀴즈의 수 로깅
    if (quizzes.isNotEmpty) {
      for (var quiz in quizzes) {
        // answers를 choices에 추가하고 랜덤으로 섞습니다.
        quiz.choices.add(quiz.answers[0]);
        quiz.choices.shuffle(Random());
      }
      updateQuizDisplay(0); // 첫 번째 퀴즈로 시작
    } else {
      print('Quiz data is empty');
    }
  }

  void updateQuizDisplay(int index) {
    if (quizzes.isNotEmpty) {
      // 리스트가 비어 있지 않은지 확인
      setState(() {
        currentQuizIndex = index;
        question = quizzes[index].word;
        choices = quizzes[index].choices;
        answers = quizzes[index].answers[0];
        correctIndex =
            quizzes[index].choices.indexOf(answers); // 정답의 새로운 인덱스 찾기
        selectedIndex = -1;
        resultMessage = '';
        submitMent = "제출하기";
        submitButtonColor = myStyle.basicGray;
      });
    } else {
      print('Quiz data is empty'); // 로그를 남기거나 사용자에게 알림
    }
  }

  void endQuiz() async {
    await saveWord(1, widget.songId);
  }

  void submitAnswer() {
    if (selectedIndex == -1 || resultMessage.isNotEmpty) {
      // 선택하지 않았거나 이미 제출한 경우
      return;
    }

    setState(() {
      if (selectedIndex == correctIndex) {
        resultMessage = '정답입니다!';
        submitButtonColor = myStyle.pointColor;
        correctCnt++;
      } else {
        resultMessage = '오답입니다. 정답: $answers';
        submitButtonColor =
            myStyle.mainColor; // Assuming you have a color set for errors
      }

      // Always allow moving to the next question after a submission
      if (currentQuizIndex < quizzes.length - 1) {
        submitMent = "다음으로";
      } else {
        submitMent = "퀴즈 끝";
        end = true; // 마지막 퀴즈
      }

      _controller.reset();
      _controller.forward(); // 애니메이션 시작
    });
  }

  Widget optionButton(String option, int index) {
    return InkWell(
      onTap: end
          ? () {}
          : () {
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
          "뜻 맞추기",
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
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
          child: Column(
            children: [
              Text(
                '${currentQuizIndex + 1}/${quizzes.length}',
                style: myStyle.textTheme.bodyMedium,
              ),
              Text(
                '정답 개수 : $correctCnt',
                style: myStyle.textTheme.bodySmall,
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        question,
                        style: myStyle.textTheme.titleLarge,
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
                      child: Text(resultMessage,
                          style: myStyle.textTheme.bodyMedium),
                    ),
                    ...choices.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 20.w),
                        child: optionButton(val, idx),
                      );
                    }).toList(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                      child: InkWell(
                        onTap: () {
                          if (submitMent == "다음으로" || submitMent == "퀴즈 끝") {
                            if (currentQuizIndex < quizzes.length - 1) {
                              updateQuizDisplay(currentQuizIndex +
                                  1); // Move to the next question
                            } else {
                              // 퀴즈가 끝났을 때
                              Get.until((route) =>
                                  Get.previousRoute == '/'); // 스택에서 두 개의 화면 제거
                              Get.to(() => QuizEndView(correctCnt: correctCnt));
                              // Get.offAll(() => QuizEndView(correctCnt: correctCnt,));
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
                              submitMent,
                              style: myStyle.textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                      child: InkWell(
                        onTap: skipToLastQuestion,
                        child: Text(
                          "마지막으로 건너뛰기",
                          style: myStyle.textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (resultMessage.isNotEmpty) // 결과 메시지가 있는 경우에만 애니메이션 실행
          Positioned(
            right: 125.w,
            bottom: resultMessage == '정답입니다!' ? 360.h : 300.h,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: resultMessage == '정답입니다!'
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          style: BorderStyle.solid,
                          width: 7,
                        ),
                      )
                    : BoxDecoration(),
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: resultMessage == '정답입니다!' ? 0.w : 110.w,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
