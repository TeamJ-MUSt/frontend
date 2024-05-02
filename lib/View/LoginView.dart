import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;

import 'mainView.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30.h,
                child: Image(image: AssetImage('assets/logo_1.png'), fit: BoxFit.fitHeight),),
            Text("노래로 공부하는 일본어",style: TextStyle(fontSize: 11.sp, color: myStyle.mainColor),),
            SizedBox(height: 30.h,),
            SizedBox(
              height: 40.h,
              child: TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디', // ID in Korean
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 5.0), // Provides space between the fields
            SizedBox(
              height: 40.h,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호', // Password in Korean
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Hides password text
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 40.h, // Adjust height accordingly
              child: SizedBox(
                width: double.infinity, // Makes the button fill the width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myStyle.mainColor, // Use your main color from the style
                    padding: EdgeInsets.symmetric(vertical: 10.h), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0.r), // Use .r for responsive radius
                    ),
                  ),
                  onPressed: () {
                    // Get.to(() => MainView());
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainView()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    '로그인',
                    style: myStyle.textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h,),
            SizedBox(
              height: 40.h, // Adjust height accordingly
              child: SizedBox(
                width: double.infinity, // Makes the button fill the width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myStyle.pointColor, // Use your main color from the style
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0.r), // Use .r for responsive radius
                    ),
                  ),
                  onPressed: () {
                    // Implement login logic
                    Get.to(() => const MainView());
                  },
                  child: Text(
                    '회원가입',
                    style: myStyle.textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h,),
            Text('아이디/비밀번호가 기억나지 않으십니까?', // Do you remember your ID/password? in Korean
                style: TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
