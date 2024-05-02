import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FillCard extends StatelessWidget {
  int count;
  String cardName;
  bool invert;
  Widget moveTo;
  FillCard(this.count, this.cardName,this.invert,this.moveTo,{super.key});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: (){
          Get.to(()=>moveTo);
        },
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: myStyle.mainColor,
              width: invert ? 2:0,
            ),
            color: invert ? Colors.white:myStyle.mainColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$count",
                    style: TextStyle(
                        color: invert ? myStyle.mainColor:Colors.white,
                        fontSize: 30.sp,
                        fontFamily: 'NotoSansCJK',
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    cardName,
                    style: TextStyle(
                        color: invert ? myStyle.mainColor:Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'NotoSansCJK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
