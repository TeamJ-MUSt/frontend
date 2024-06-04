import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SongDetailCard extends StatelessWidget {
  SongDetailCard({required this.musicInfo, super.key});

  List musicInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.h,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54,
              blurRadius: 1.0,
              offset: Offset(1.0, 2.0))
        ],
        color: Colors.white,
      ),
      // width: 340.w,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100.w, child: Image.network(musicInfo[2])),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "level",
                ),
                Text(
                  musicInfo[0],
                  overflow: TextOverflow.ellipsis,
                  style: myStyle.textTheme.bodyMedium,
                ),
                Text(
                  musicInfo[1],
                  style: myStyle.textTheme.displayMedium,
                )
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border_outlined,
              size: 25.h,
              color: myStyle.mainColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
