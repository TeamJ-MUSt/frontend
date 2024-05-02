import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/json2.dart';
import '../../data/searchJson.dart';
import '../EnrollView/EnrollSearchView.dart';
import '../Widget/SongListWidget.dart';

class FindDataView extends StatelessWidget {
  String query;
  AsyncSnapshot<List<SearchSong>> snapshot;
  var thumbnail;

  FindDataView({required this.query, required this.snapshot, required this.thumbnail,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${query}에 대한 검색 결과입니다",
            style: myStyle.textTheme.bodyMedium,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                SearchSong songs = snapshot.data![index];
                // return SongListWidgetNoPic(
                //     title: song.title, artist: song.artist
                //     );
                return SongListWidget(song: songs,thumbnail: thumbnail,);
              },
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => EnrollSearchView(query: query));
            },
            child: Text(
              '원하는 노래가 없나요?',
              style: myStyle.textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
