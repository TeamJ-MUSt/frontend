import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/LearningView/SequenceQuizView.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';

class SeqQuizSetWidget extends StatefulWidget {

  SeqQuizSetWidget({required this.content, required this.comment, required this.songId, super.key});
  String content;
  String comment;
  final int songId;

  @override
  State<SeqQuizSetWidget> createState() => _SeqQuizSetWidgetState();
}

class _SeqQuizSetWidgetState extends State<SeqQuizSetWidget> {
  @override
  void initState() {
    super.initState();
  }
  void loadQuizData() async {
    print('Loading quiz data for songId: ${widget.songId}');
    var quizSet = await fetchQuizData(widget.songId,'SENTENCE');
    print('Quiz data fetched: ${quizSet.toString()}');
    if (quizSet.success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("퀴즈 세트"),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: 400.0, // 최대 높이를 설정하여 overflow 방지
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  quizSet.setNum,
                      (index) => ListTile(
                    title: Text('퀴즈 ${index+1}'),
                    onTap: () {
                      Navigator.of(context).pop(); // AlertDialog 닫기
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SequenceQuizView(
                            songId: widget.songId,
                            setNum: index,
                          ), // 상세 페이지로 이동
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      createQuiz('SENTENCE',widget.songId);
      print(widget.songId);
      print("create quizSet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        loadQuizData();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        child: Row(
          children: [
            Icon(
              Icons.circle_outlined,
              color: myStyle.mainColor,
              size: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.content,
                  style: myStyle.textTheme.bodySmall,
                ),
                Text(
                  widget.comment,
                  style: myStyle.textTheme.displaySmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
