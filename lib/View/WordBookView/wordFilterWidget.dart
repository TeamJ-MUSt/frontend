import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

// MemorizationButton 위젯 정의
class wordFilterWidget extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onPress;
  final String txt;

  const wordFilterWidget({
    Key? key,
    required this.isSelected,
    required this.onPress,
    required this.txt,
  }) : super(key: key);

  @override
  _wordFilterWidgetState createState() => _wordFilterWidgetState();
}

class _wordFilterWidgetState extends State<wordFilterWidget> {
  TextStyle get textStyle => TextStyle(
    fontSize: 13.sp,
    fontFamily: 'NotoSansCJK',
    color: widget.isSelected ? Color(0xFFFFFFFF) : Color(0x7FFFFFFF),
  );

  Color get buttonColor => widget.isSelected ? Color(0xFFCC2036) : Color(0x7FCC2036);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPress,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
      ),
      child: Text(
        widget.txt,
        style: textStyle,
      ),
    );
  }
}
