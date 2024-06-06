import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;
import '../../data/SeqQuizJson.dart';
import '../../data/api_service.dart';
import '../../data/getApi.dart';
import '../../data/googleTranslate2.dart';
import '../Widget/check_anime.dart';
import 'QuizEndView.dart';

class SequenceQuizView extends StatefulWidget {
  SequenceQuizView({required this.songId, required this.setNum, super.key});
  final int songId;
  final int setNum;

  @override
  _SequenceQuizViewState createState() => _SequenceQuizViewState();
}

class _SequenceQuizViewState extends State<SequenceQuizView> with SingleTickerProviderStateMixin {
  List<SeqQuiz> quizzes = [];
  int currentQuizIndex = 0;
  List<int> selectedIndices = [];
  bool isCorrect = false;
  bool isSubmit = false;
  String submitMent = '제출하기'; // 제출멘트
  Color submitButtonColor = myStyle.basicGray; // 선택버튼색
  String resultText = "";

  // final _translationService = TranslationService("API_KEY");
  String translatedText = '';
  String papagotranslatedText = '';
  int correctCnt = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late GoogleTranslateService _translationService;

  @override
  void initState() {
    super.initState();
    getQuiz();
    _translationService = GoogleTranslateService(dotenv.env['GOOGLE_TRANSLATE_API_KEY']!);

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

  Future<void> getQuiz() async {
    print('getQuiz');
    quizzes = await getSeqQuizSet(widget.setNum, widget.songId);  // 클래스 레벨의 quizzes를 직접 업데이트
    print("Loaded ${quizzes.length} quizzes."); // 로드된 퀴즈의 수 로깅
    if (quizzes.isNotEmpty) {
      updateQuizDisplay(); // 첫 번째 퀴즈로 시작
    } else {
      print('Quiz data is empty');
    }
  }

  void _translateCurrentQuiz() async {
    try {
      final text = quizzes[currentQuizIndex].answers[0];
      final translated = await _translationService.translate(text);

      setState(() {
        translatedText = translated;
      });
    } catch (e) {
      print('Translation error: $e');
      setState(() {
        translatedText = '번역 실패: $e';
      });
    }
  }

  void selectWord(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
      if (selectedIndices.length == quizzes[currentQuizIndex].choices.length) {
        submitButtonColor = myStyle.mainColor;
      } else {
        submitButtonColor = myStyle.basicGray;
      }
    });
  }


  String arrangeLyrics(String lyrics){
    String returnLyric;
    returnLyric = lyrics.replaceAll(' ', '');
    returnLyric = returnLyric.replaceAll("​","");
    returnLyric = returnLyric.replaceAll("「","");
    returnLyric = returnLyric.replaceAll("」","");
    return returnLyric;
  }

  void submitAnswer() {
    setState(() {
      isSubmit = true;
      String real_answer = arrangeLyrics(quizzes[currentQuizIndex].answers[0]);
      String selectedWords = selectedIndices.map((i) => quizzes[currentQuizIndex].choices[i]).join('');
      if (selectedWords == real_answer) {
        isCorrect = true;
        submitButtonColor = myStyle.pointColor;
        submitMent = "다음으로";
        correctCnt++;
      } else {
        isCorrect = false;
        submitButtonColor = myStyle.mainColor;
      }
      _controller.reset();
      _controller.forward();
    });
  }

  void resetSelection() {
    setState(() {
      selectedIndices.clear();
      isSubmit = false;
      submitButtonColor = myStyle.basicGray;
    });
  }

  void updateQuizDisplay() {
    setState(() {
      selectedIndices.clear();
      isCorrect = false;
      isSubmit = false;
      submitMent = "제출하기";
      submitButtonColor = myStyle.basicGray;
      resultText = "";
      _translateCurrentQuiz();
      // papagotranslateCurrentQuiz();
    });
  }

  void goToNextQuiz() {
    if (currentQuizIndex < quizzes.length - 1) {
      setState(() {
        currentQuizIndex++;
        updateQuizDisplay();
      });
    } else {
      print("마지막 퀴즈입니다.");
      Get.until((route) => Get.previousRoute == '/'); // 스택에서 두 개의 화면 제거
      Get.to(() => QuizEndView(correctCnt: correctCnt));
    }
  }

  void endQuiz() async {
    await saveWord(1, widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    if (quizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuiz = quizzes[currentQuizIndex];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "문장 만들기 퀴즈",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          translatedText,
                          style: myStyle.textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          selectedIndices.map((i) => currentQuiz.choices[i]).join(''),
                          style: myStyle.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSubmit == true) Text(isCorrect ? "정답입니다" : "오답입니다"),
                Text(
                  resultText,
                  style: myStyle.textTheme.titleSmall,
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: List.generate(currentQuiz.choices.length, (index) {
                            final word = currentQuiz.choices[index];
                            return ElevatedButton(
                              onPressed: () {
                                selectWord(index);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: selectedIndices.contains(index)
                                    ? Colors.black
                                    : Colors.white,
                                backgroundColor: selectedIndices.contains(index)
                                    ? myStyle.basicGray
                                    : myStyle.mainColor,
                                elevation: 0,
                              ),
                              child: Text(
                                word,
                                style: TextStyle(
                                  color: selectedIndices.contains(index)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                  child: InkWell(
                    onTap: (){
                      currentQuizIndex = quizzes.length - 1;
                      goToNextQuiz();
                    },
                    child: Text(
                      "마지막으로 건너뛰기",
                      style: myStyle.textTheme.headlineMedium,
                    ),
                  ),
                ),
                if (isSubmit && !isCorrect)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          resultText = '정답 : ${quizzes[currentQuizIndex].answers[0]}';
                          submitMent = "다음으로";
                          submitButtonColor = myStyle.pointColor;
                          isSubmit = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: myStyle.mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            '정답확인하기',
                            style: myStyle.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                  child: InkWell(
                    onTap: () {
                      if (submitMent == "제출하기") {
                        if (selectedIndices.length == currentQuiz.choices.length) {
                          submitAnswer();
                        }
                      } else if (submitMent == "다음으로") {
                        goToNextQuiz();
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
              ],
            ),
          ),
          if (isSubmit)
            CheckAnime(
              resultMessage: isCorrect ? '정답입니다!' : '오답입니다!',
            ),
        ],
      ),
    );
  }
}
