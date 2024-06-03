import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/WordBookView/wordFilterWidget.dart';
import 'package:must/data/simWordJson.dart';
import 'package:must/style.dart' as myStyle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_service.dart';
import '../../data/wordJson.dart';

class WordBookView extends StatefulWidget {
  @override
  _WordBookViewState createState() => _WordBookViewState();
}

class _WordBookViewState extends State<WordBookView> {
  List<Word> words = [];
  List<bool> selection = [true, true];
  int hidden = -1;
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
      hidden = (hidden == index) ? -1 : index;
    });
  }

  void loadWordsData() async {
    try {
      words = await getWordbook(1);
      print("Loaded ${words.length} words.");
      setState(() {});
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

  void showWordDialog(BuildContext context, Word word) async {
    List<SimWord> wordlist = await simWordget(word.id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${word.spell}의 유사단어"),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              wordlist.length,
                  (index) {
                SimWord simWord = wordlist[index];
                return ListTile(
                  title: Text(simWord.spell),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('읽기: ${simWord.japPro}'),
                      Text('품사: ${simWord.classOfWord}'),
                      Text('뜻: ${simWord.meaning.join(', ')}'),
                    ],
                  ),
                );
              },
            ),
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
                    SizedBox(width: 5.w),
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
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Expanded(
              child: ListView.separated(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  Word word = words[index];

                  // 필터링 로직
                  bool shouldDisplay = (selection[0] &&
                      memorizedWords.contains(word.spell)) ||
                      (selection[1] && !memorizedWords.contains(word.spell));
                  if (!shouldDisplay) return SizedBox.shrink();

                  return InkWell(
                    onTap: () {
                      showWordDialog(context, word);
                    },
                    child: IntrinsicHeight(
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            right: 0,
                            child: TextButton(
                              child: Text(
                                memorizedWords.contains(word.spell)
                                    ? "암기 완료"
                                    : "암기 중",
                                style: myStyle.textTheme.labelSmall,
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  hidden == 1
                                      ? "${word.spell}"
                                      : "${word.spell} (${word.japPro})",
                                  style: myStyle.textTheme.labelMedium,
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  hidden == 0
                                      ? "[${word.classOfWord}]"
                                      : "[${word.classOfWord}] ${word.meaning.join(', ')}",
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
                          ),
                        ],
                      ),
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
