import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/WordBookView/wordFilterWidget.dart';
import 'package:must/style.dart' as myStyle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_service.dart';
import '../../data/wordJson.dart'; // Ensure this path is correct for Word model

class WordBookView extends StatefulWidget {
  @override
  _WordBookViewState createState() => _WordBookViewState();
}

class _WordBookViewState extends State<WordBookView> {
  List<Word> words = [];
  List<bool> selection = [true, true];
  List<bool> hide = [false, false];
  int hidden = -1;
  Color txtColor = Color(0x5FCC2036);
  Set<String> memorizedWords = Set<String>();

  @override
  void initState() {
    super.initState();
    loadWordsData();
    loadMemorizedWords();
  }

  void buttonPress(int index) {
    setState(() {
      selection[index] = !selection[index];
    });
  }

  void hideWhat(int index) {
    setState(() {
      if (hidden == -1) {
        hidden = index;
      } else {
        if (index == hidden) {
          // 두번 터치하면 취소
          hidden = -1;
        } else {
          // 한번 선택된 상태에서 다른거를 누르면 바뀜
          hidden = index;
        }
      }
      print(index);
    });
  }

  void loadWordsData() async {
    try {
      words = await notAPIWordData();
      print("Loaded ${words.length} words.");

      setState(() {
        // 데이터 로딩 후 UI 갱신
        if (words.isNotEmpty) {
          print("word not empty");
        } else {
          print('Word data is empty');
        }
      });
    } catch (e) {
      print('Error loading word data: $e');
    }
  }

  void loadMemorizedWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memorizedWords =
          prefs.getStringList('memorizedWords')?.toSet() ?? Set<String>();
    });
  }

  void saveMemorizedWord(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memorizedWords.add(word);
      prefs.setStringList('memorizedWords', memorizedWords.toList());
    });
  }

  void removeMemorizedWord(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memorizedWords.remove(word);
      prefs.setStringList('memorizedWords', memorizedWords.toList());
    });
  }

  void showWordDialog(BuildContext context, Word word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${word.spell}의 유사단어"),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("읽기: ${word.japPro}"),
              Text("뜻: ${word.meaning}"),
              Text("품사: ${word.classOfWord}"),
              Text("포함된 단어: ${word.involvedSongs.join(', ')}"),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: Text('추가'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    wordFilterWidget(
                      isSelected: selection[0],
                      onPress: () {
                        buttonPress(0);
                      },
                      txt: "암기 완료",
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    wordFilterWidget(
                      isSelected: selection[1],
                      onPress: () {
                        buttonPress(1);
                      },
                      txt: "암기 중",
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        hideWhat(0);
                      },
                      child: Text(
                        "• 뜻 숨김",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'NotoSansCJK',
                          color: hidden == 0
                              ? Color(0xFFCC2036)
                              : Color(0x5FCC2036),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        hideWhat(1);
                      },
                      child: Text(
                        "• 발음 숨김",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'NotoSansCJK',
                          color: hidden == 1
                              ? Color(0xFFCC2036)
                              : Color(0x5FCC2036),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: words.isNotEmpty ? words.length * 2 - 1 : 0,
                itemBuilder: (context, index) {
                  if (index % 2 == 1) {
                    return const Divider(
                        height: 1, color: Colors.grey); // 홀수 인덱스에 Divider 배치
                  }
                  int itemIndex = index ~/ 2; // 짝수 인덱스에 해당하는 데이터 인덱스
                  Word word = words[itemIndex];

                  // 필터링 로직
                  bool shouldDisplay = (selection[0] &&
                      memorizedWords.contains(word.spell)) ||
                      (selection[1] && !memorizedWords.contains(word.japPro));
                  if (!shouldDisplay) return SizedBox.shrink();

                  return InkWell(
                    onTap: () {
                      showWordDialog(context, word);
                    },
                    child: SizedBox(
                      height: 70.h,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                memorizedWords.contains(word.spell)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: memorizedWords.contains(word.spell)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                if (memorizedWords.contains(word.spell)) {
                                  removeMemorizedWord(word.spell);
                                } else {
                                  saveMemorizedWord(word.spell);
                                }
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                hidden == 1
                                    ? "${word.spell}"
                                    : "${word.spell} (${word.japPro})",
                                style: myStyle.textTheme.labelMedium,
                              ),
                              Text(
                                hidden == 0
                                    ? "[${word.classOfWord}]"
                                    : "[${word.classOfWord}] ${word.meaning}",
                                style: myStyle.textTheme.labelMedium,
                              ),
                              Text(
                                word.involvedSongs.map((item) => '#$item').join(' '),
                                style: myStyle.textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
