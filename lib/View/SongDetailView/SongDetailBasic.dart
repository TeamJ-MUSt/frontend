import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/LearningView/MeaningQuizView.dart';
import 'package:must/View/LearningView/SequenceQuizView.dart';
import 'package:must/View/WordBookView/WordBookView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:must/View/Widget/LearningWidget.dart';
import 'package:must/View/Widget/SongDetailCard.dart';

import '../LearningView/ReadQuizView.dart';

class SongDetail extends StatefulWidget {
  SongDetail({required this.musicInfo, super.key});

  List musicInfo;

  @override
  State<SongDetail> createState() => _SongDetailState(musicInfo: musicInfo);
}

class _SongDetailState extends State<SongDetail> {
  _SongDetailState({required this.musicInfo});

  List musicInfo;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: Column(
          children: [
            SongDetailCard(musicInfo: musicInfo),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "학습하기",
                  style: myStyle.textTheme.bodyLarge,
                ),
                Row(
                  children: [
                    Text("아는 단어 제외"),
                    Switch(
                      activeColor: myStyle.mainColor,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(
                          () {
                            _isChecked = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LearningWidget(
                      content: '단어장',
                      comment: '노래에 등장하는 단어들을 확인합니다',
                      moveTo: WordBookView(),
                    ),
                    // LearningWidget(
                    //   content: '단어 퀴즈 - 뜻 맞추기',
                    //   comment: '단어를 보고 한국어 뜻을 골라주세요',
                    //   moveTo: MeaningQuizView(songId: 1,),
                    // ),
                    LearningWidget(
                      content: '단어 퀴즈 - 발음 맞추기',
                      comment: '단어를 보고 알맞은 발음을 골라주세요',
                      moveTo: ReadQuizView(songId: 1, setNum: 1,),
                    ),
                    LearningWidget(
                      content: '순서맞추기',
                      comment: '뜻을 보고 문장의 순서를 맞춰주세요',
                      moveTo: SequenceQuizView(),
                    ),
                    Text("가사",style: myStyle.textTheme.bodyLarge,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                      child: Text(musicInfo[3]),
                      // child: Text("空にある何かを見つめてたら\nそれは星だって君がおしえてくれた\nまるでそれは僕らみたいに  寄り添ってる\nそれを泣いたり笑ったり繋いでいく\n何十回  何百回  ぶつかりあって\n何十年  何百年  昔の光が​\n星自身も忘れたころに​\n僕らに届いてる​\n僕ら見つけあって  手繰りあって  同じ空​\n輝くのだって  二人だって  約束した​\n遥か遠く終わらないべテルギウス​\n誰かに繋ぐ魔法​\n僕ら  肩並べ  手取り合って  進んでく​\n辛い時だって  泣かないって  誓っただろう​\n遥か遠く終わらないべテルギウス​\n君にも見えるだろう  祈りが​\n記憶を辿るたび  蘇るよ​\n君がいつだってそこに居てくれること​\nまるでそれは星の光と  同じように​\n今日に泣いたり笑ったり繋いでいく​\n何十回  何百回  ぶつかりあって​\n何十年  何百年  昔の光が​\n僕自身も忘れたころに​\n僕らを照らしてる​\n僕ら見つけあって  手繰りあって  同じ空​\n輝くのだって  二人だって  約束した​\n遥か遠く終わらないべテルギウス​\n誰かに繋ぐ魔法​\nどこまで  いつまで  生きられるか​\n君が不安になるたびに強がるんだ​\n大丈夫  僕が横にいるよ​\n見えない線を繋ごう​\n僕ら見つけあって  手繰りあって  同じ空​\n輝くのだって  二人だって  約束した​\n遥か遠く終わらないべテルギウス​\n誰かに繋ぐ魔法​\n僕ら 肩並べ 手取り合って 進んでく​\n辛い時だって  二人だって  誓っただろう​\n遥か遠く終わらないべテルギウス​\n君にも見えるだろう  祈りが​\n空にある何かを見つめてたら​\nそれは星だって君がおしえてくれた​", style: myStyle.textTheme.bodySmall,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
