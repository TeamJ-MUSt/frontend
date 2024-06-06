import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../../data/musicWordJson.dart';
import '../../data/searchJson.dart';

class SongWordBookView extends StatefulWidget {
  SongWordBookView({required this.song, super.key});
  SearchSong song;

  @override
  _SongWordBookViewState createState() => _SongWordBookViewState();
}

class _SongWordBookViewState extends State<SongWordBookView> {
  List<SongWord> words = [];
  bool isLoading = true;  // 로딩 상태를 추적하는 변수
  String errorMessage = '';  // 에러 메시지를 저장하는 변수

  @override
  void initState() {
    super.initState();
    loadWordsData();
  }

  void loadWordsData() async {
    try {
      List<SongWord> songwords = await getSongWordbook(widget.song.songId);
      setState(() {
        words = songwords;
        isLoading = false;  // 로딩 상태 업데이트
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading word data: $e';
        print(e);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.song.title}의 단어장", style: TextStyle(fontSize: 15.sp),), backgroundColor: Colors.white, foregroundColor: myStyle.mainColor,),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        child: isLoading
            ? Center(child: CircularProgressIndicator())  // 로딩 중일 때 로딩 인디케이터 표시
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))  // 에러가 발생했을 때 에러 메시지 표시
            : Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  SongWord word = words[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${word.spell} (${word.japPro})",
                          style: myStyle.textTheme.labelMedium,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "[${word.classOfWord}] ${word.meaning.join(', ')}",
                          style: myStyle.textTheme.labelSmall,
                        ),
                        Text(
                          word.involvedSongs
                              .map((item) => '#$item')
                              .join(' '),
                          style: myStyle.textTheme.displaySmall,
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
