import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/LearningView/MeaningQuizView.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';

class MeaningQuizSetWidget extends StatefulWidget {
  MeaningQuizSetWidget({
    required this.content,
    required this.comment,
    required this.songId,
    super.key,
  });

  final String content;
  final String comment;
  final int songId;

  @override
  State<MeaningQuizSetWidget> createState() => _MeaningQuizSetWidgetState();
}

class _MeaningQuizSetWidgetState extends State<MeaningQuizSetWidget> {
  @override
  void initState() {
    super.initState();
  }

  void loadQuizData() async {
    //퀴즈조회
    var quizSet = await fetchQuizData(widget.songId,'MEANING');

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
                  quizSet.setNum-1,
                      (index) => ListTile(
                    title: Text('퀴즈 ${index + 1}'),
                    onTap: () {
                      // 각각의 ListTile을 클릭했을 때의 작업 정의
                      Navigator.of(context).pop(); // AlertDialog 닫기
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeaningQuizView(
                            songId: widget.songId,
                            setNum: index + 1,
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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