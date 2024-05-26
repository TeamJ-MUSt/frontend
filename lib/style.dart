import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


const Color pointColor = Color(0xFF192D76);
const Color mainColor = Color(0xFFCC2036);
const Color basicGray = Color(0x7F000000);
var textTheme = TextTheme(
    //퀴즈
    titleLarge : TextStyle(fontSize: 26.sp, fontFamily: 'NotoSansCJK',color: Colors.black),
    titleMedium: TextStyle(fontSize: 19.sp, fontFamily: 'NotoSansCJK',color: Colors.black),
    titleSmall: TextStyle(fontSize: 16.sp, fontFamily: 'NotoSansCJK',color: Colors.black),

    headlineLarge: TextStyle(fontSize: 16.sp,fontFamily: 'NotoSansCJK',fontWeight: FontWeight.w600,color: Colors.white),
    headlineMedium: TextStyle(fontSize: 15.sp,fontFamily: 'NotoSansCJK',color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16.sp,fontFamily: 'NotoSansCJK',fontWeight: FontWeight.w600,color: Color(0xFFCC2036)),
    displaySmall: TextStyle(fontSize: 13.sp, fontFamily: 'NotoSansCJK',color: basicGray),
    displayMedium: TextStyle(fontSize: 15.sp, fontFamily: 'NotoSansCJK',color: basicGray),
    displayLarge: TextStyle(fontSize: 18.sp, fontFamily: 'NotoSansCJK',fontWeight: FontWeight.w600,color: basicGray,),
    labelLarge: TextStyle(fontSize: 13.sp, fontFamily: 'NotoSansCJK',fontStyle: FontStyle.normal),
    bodyMedium: TextStyle(fontSize: 16.sp, fontFamily: 'NotoSansCJK',fontWeight: FontWeight.w600, color: Colors.black),
    labelMedium: TextStyle(fontSize: 15.sp,fontFamily: 'NotoSansCJK', fontWeight: FontWeight.w400, color: Colors.black, ),
    bodySmall: TextStyle(fontSize: 14.sp, fontFamily: 'NotoSansCJK',color: Colors.black),
);
var theme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    elevation: 1, // 그림자 정도
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),
);