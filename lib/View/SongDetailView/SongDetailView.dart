import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/Widget/MeaningQuizSetWidget.dart';
import 'package:must/View/WordBookView/SongWordBook.dart';
import 'package:must/style.dart' as myStyle;
import 'package:must/View/Widget/SeqQuizSetWidget.dart';
import 'package:must/View/Widget/SongDetailCardAPI.dart';

import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../Widget/ReadQuizSetWidget.dart';

class SongDetailView extends StatefulWidget {
  SongDetailView({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;

  @override
  State<SongDetailView> createState() =>
      _SongDetailViewState(song: song, thumbnail: thumbnail);
}

class _SongDetailViewState extends State<SongDetailView> {
  _SongDetailViewState({required this.song, required this.thumbnail});

  SearchSong song;
  var thumbnail;
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
            SongDetailCardAPI(
              song: song,
              thumbnail: thumbnail,
            ),
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
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()  {
                        Get.to(()=> SongWordBookView(song: song));
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
                                  '단어장',
                                  style: myStyle.textTheme.bodySmall,
                                ),
                                Text(
                                  '노래에 등장하는 단어들을 확인합니다',
                                  style: myStyle.textTheme.displaySmall,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    MeaningQuizSetWidget(
                      content: '단어 퀴즈 - 뜻 맞추기',
                      comment: '단어를 보고 한국어 뜻을 골라주세요',
                      songId: song.songId,
                    ),
                    ReadQuizSetWidget(
                      content: '단어 퀴즈 - 발음 맞추기',
                      comment: '단어를 보고 알맞은 발음을 골라주세요',
                      songId: song.songId,
                    ),
                    SeqQuizSetWidget(
                      content: '순서맞추기',
                      comment: '뜻을 보고 문장의 순서를 맞춰주세요',
                      songId: song.songId,
                    ),
                    Text(
                      "가사",
                      style: myStyle.textTheme.bodyLarge,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                      child: Text(
                        song.lyrics.replaceAll('\\n', '\n'),
                        style: TextStyle(fontSize: 13.sp, height: 1.5),
                      ),
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
