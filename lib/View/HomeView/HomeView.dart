import 'package:flutter/material.dart';
import 'package:must/View/HomeView/LevelView.dart';
import 'package:must/View/HomeView/MyLearningView.dart';

import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Navigation_tem.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                    indicatorColor: myStyle.mainColor,
                    labelColor: Colors.black,
                    // 선택된 탭의 라벨 색상
                    unselectedLabelColor: myStyle.basicGray,
                    // 선택되지 않은 탭의 라벨 색상
                    labelStyle: const TextStyle(
                        fontFamily: 'NotoSansCJK',
                        fontSize: 14,
                        color: Colors.black),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        text: '나의 학습',
                        height: 36.h,
                      ),
                      Tab(
                        text: '둘러보기',
                        height: 36.h,
                      ),
                      Tab(
                        text: '난이도별',
                        height: 36.h,
                      ),
                    ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(child: MyLearningView()),
                      const Center(child: NavigationTem()),
                      const Center(
                        child: LevelView(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
