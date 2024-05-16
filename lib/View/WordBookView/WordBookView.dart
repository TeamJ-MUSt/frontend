import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/WordBookView/wordFilterWidget.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../../data/wordJson.dart'; // Ensure this path is correct for Song model

class WordBookView extends StatefulWidget {
  @override
  _WordBookViewState createState() => _WordBookViewState();
}

class _WordBookViewState extends State<WordBookView> {
  List<Word> words = [];
  List<bool> selection = [true, true];
  List<bool> hide = [false, false];
  int hidden = -1;
  Color txtColor = Color(0x5FCC2036);

  @override
  void initState() {
    super.initState();
    loadWordsData();
  }

  void buttonPress(int index) {
    setState(() {
      selection[index] = !selection[index];
    });
  }
  void hideWhat(int index){
    setState(() {
      if(hidden==-1){
        hidden = index;
      }else{
        if(index==hidden) {
          //두번 터치하면 취소
          hidden = -1;
        } else {
          // 한번 선택된 상태에서 다른거를 누르면 바뀜
          hidden=index;
        }
      }
      print(index);
    });
  }

  void loadWordsData() async {
    try {
      words = await notAPIWordData();
      print("Loaded ${words.length} words.");

      setState(() {
        // 데이터 로딩 후 UI 갱신
        if (words.isNotEmpty) {
          print("word not empty");
        } else {
          print('Word data is empty');
        }
      });
    } catch (e) {
      print('Error loading word data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    wordFilterWidget(
                      isSelected: selection[0],
                      onPress: () {
                        buttonPress(0);
                      },
                      txt: "암기 완료",
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    wordFilterWidget(
                      isSelected: selection[1],
                      onPress: () {
                        buttonPress(1);
                      },
                      txt: "암기 중",
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        hideWhat(0);
                      },
                      child: Text(
                        "• 뜻 숨김",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'NotoSansCJK',
                          color: hidden == 0? Color(0xFFCC2036) : Color(0x5FCC2036),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        hideWhat(1);
                      },
                      child: Text(
                        "• 발음 숨김",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'NotoSansCJK',
                          color: hidden == 1? Color(0xFFCC2036) : Color(0x5FCC2036),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: words.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index % 2 == 1)
                    return const Divider(
                        height: 1, color: Colors.grey); // 홀수 인덱스에 Divider 배치
                  int itemIndex = index ~/ 2; // 짝수 인덱스에 해당하는 데이터 인덱스
                  Word word = words[itemIndex];
                  return SizedBox(
                    height: 70.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [ //0은 뜻 숨김 1은 발음 숨김
                        Text(
                          hidden==1 ? "${word.write}" : "${word.write} (${word.read})",
                          style: myStyle.textTheme.labelMedium,
                        ),
                        Text(
                          hidden==0 ? "[${word.wordClass}]" : "[${word.wordClass}] ${word.mean}",
                          style: myStyle.textTheme.labelMedium,
                        ),
                        Text(
                          word.include.map((item) => '#$item').join(' '),
                          style: myStyle.textTheme.displayMedium,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
