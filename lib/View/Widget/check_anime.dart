import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckAnime extends StatefulWidget {
  CheckAnime({required this.resultMessage, super.key});
  String resultMessage;

  @override
  State<CheckAnime> createState() => _CheckAnimeState();
}

class _CheckAnimeState extends State<CheckAnime> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 125.w,
      bottom: widget.resultMessage == '정답입니다!' ? 360.h : 300.h,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: widget.resultMessage == '정답입니다!'
              ? BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
              style: BorderStyle.solid,
              width: 7,
            ),
          )
              : BoxDecoration(),
          child: Center(
            child: Icon(
              Icons.close,
              size: widget.resultMessage == '정답입니다!' ? 0.w : 110.w,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
