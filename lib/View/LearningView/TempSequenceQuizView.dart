import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/SeqQuizJson2.dart';
import '../../data/api_service.dart';
import '../../data/googleTranslate2.dart';

class TempSequenceQuizView extends StatefulWidget {
  @override
  _TempSequenceQuizViewState createState() => _TempSequenceQuizViewState();
}

class _TempSequenceQuizViewState extends State<TempSequenceQuizView> {
  List<SeqQuiz2> quizzes = [];
  int currentQuizIndex = 0;
  List<String> selectedWords = [];
  bool isCorrect = false;
  bool isSubmit = false;
  String submitMent = '제출하기'; // 제출멘트
  Color submitButtonColor = myStyle.basicGray; // 선택버튼색
  String resultText = "";

  late GoogleTranslateService _translationService;
  String translatedText = "";

  @override
  void initState() {
    super.initState();
    _translationService = GoogleTranslateService(dotenv.env['GOOGLE_TRANSLATE_API_KEY']!);
    loadQuizData().then((data) {
      setState(() {
        quizzes = data;
      });
      _translateCurrentQuiz();
    }).catchError((error) {
      print(error);
    });
  }

  void _translateCurrentQuiz() async {
    try {
      final text = quizzes[currentQuizIndex].answer;
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

  void selectWord(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else {
        selectedWords.add(word);
      }
      if (selectedWords.length == quizzes[currentQuizIndex].options.length) {
        submitButtonColor = myStyle.mainColor;
      } else {
        submitButtonColor = myStyle.basicGray;
      }
    });
  }

  void submitAnswer() {
    setState(() {
      isSubmit = true;
      if (selectedWords.join('') == quizzes[currentQuizIndex].answer) {
        isCorrect = true;
        submitButtonColor = myStyle.pointColor;
        submitMent = "다음으로";
      } else {
        isCorrect = false;
        submitButtonColor = myStyle.mainColor;
      }
    });
  }

  void resetSelection() {
    setState(() {
      selectedWords.clear();
      isSubmit = false;
      submitButtonColor = myStyle.basicGray;
    });
  }

  void nextQuiz() {
    setState(() {
      if (currentQuizIndex < quizzes.length - 1) {
        currentQuizIndex++;
        selectedWords.clear();
        isCorrect = false;
        isSubmit = false;
        submitMent = "제출하기";
        submitButtonColor = myStyle.basicGray;
        resultText = "";
        _translateCurrentQuiz();
      } else {
        print("마지막 퀴즈입니다.");
      }
    });
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${currentQuizIndex + 1}/${quizzes.length}',
              style: myStyle.textTheme.bodyMedium,
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
                      selectedWords.join(' '),
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
                      children: currentQuiz.options.map((word) {
                        return ElevatedButton(
                          onPressed: () {
                            selectWord(word);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: selectedWords.contains(word)
                                ? Colors.black
                                : Colors.white,
                            backgroundColor: selectedWords.contains(word)
                                ? myStyle.basicGray
                                : myStyle.mainColor,
                            elevation: 0,
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                              color: selectedWords.contains(word)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isSubmit && !isCorrect)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      resultText = '정답 : ${quizzes[currentQuizIndex].answer}';
                      submitMent = "다음으로";
                      submitButtonColor = myStyle.mainColor;
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
                    if (selectedWords.length == currentQuiz.options.length) {
                      submitAnswer();
                    }
                  } else if (submitMent == "다음으로") {
                    nextQuiz();
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
    );
  }
}
