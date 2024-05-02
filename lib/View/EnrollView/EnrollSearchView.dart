import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:must/View/Widget/SongListSmall.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/json.dart';
import '../../data/jsondata.dart';

class EnrollSearchView extends StatelessWidget {
  String query;
  EnrollSearchView({required this.query, super.key});
  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.parseUserList(jsonString);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Text("$query가 다음 중에 있나요?",style: myStyle.textTheme.bodyLarge,),
            ),
            SongListSmall(songWidget: songs[0]),
            SongListSmall(songWidget: songs[1]),
          ],
        ),
      ),
    );
  }
}
