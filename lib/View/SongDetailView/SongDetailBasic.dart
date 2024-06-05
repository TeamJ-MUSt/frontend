import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;
import 'package:must/View/Widget/SongDetailCard.dart';

import '../../data/api_service.dart';
import '../../data/musicWordJson.dart';
import '../../data/wordJson.dart';
import '../global_state.dart';


class SongDetail extends StatefulWidget {
  SongDetail({required this.musicInfo, super.key});
  List musicInfo;

  @override
  State<SongDetail> createState() => _SongDetailState(musicInfo: musicInfo);
}

class _SongDetailState extends State<SongDetail> {
  _SongDetailState({required this.musicInfo});

  List<SongWord> words = [];
  List musicInfo;
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
    loadWordsData();
  }

  void loadWordsData() async {
    try {
      words = await getSongWordbook(1);
      setState(() {});
    } catch (e) {
      print('Error loading word data: $e');
    }
  }

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
                    Text("가사",style: myStyle.textTheme.bodyLarge,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                      child: Text(musicInfo[3]),
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
