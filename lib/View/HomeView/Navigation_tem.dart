import 'package:flutter/material.dart';
import 'package:must/View/Widget/recommandWidget.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/json.dart';
import '../../data/jsondata.dart';
import '../Widget/albumWidget.dart';

class NavigationTem extends StatelessWidget {
  const NavigationTem({super.key});

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.parseUserList(jsonString);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            height: 125.h,
            decoration: BoxDecoration(color: myStyle.mainColor),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: myStyle.mainColor,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "오늘의 오스스메",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'NotoSansCJK',
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          RecommandWidget(
                              title: songs[0].title,
                              artist: songs[0].artist,
                              thumbnail: songs[0].thumbnail)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_outlined,
                            size: 35.h,
                            color: myStyle.mainColor,
                          ),
                          Text(
                            "학습 바로가기",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'NotoSansCJK',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFCC2036)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "인기 Top10",
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
            child: Container(
              // color: Colors.black,
              child: AlbumWidget(songs),
            ),
          )
        ],
      ),
    );
  }
}
