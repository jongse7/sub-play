import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'recommend_screen.dart';

class PlayLoadingScreen extends StatefulWidget {
  final int contentsNum;
  const PlayLoadingScreen({required this.contentsNum, Key? key}) : super(key: key);

  @override
  State<PlayLoadingScreen> createState() => _PlayLoadingScreenState();
}

class _PlayLoadingScreenState extends State<PlayLoadingScreen> {
  @override
  void initState() {
    super.initState();
    delay();
  }

  void delay() async {
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecommendScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0XFF9C88FE),
              Color(0xff4C3D9C),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.35),
            LoadingAnimationWidget.waveDots(
              color: Color(0xffDDD9F4),
              size: 56.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.02),
            Image.asset(
              "asset/map/train.png",
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),
            Text('하차역까지 총 ${widget.contentsNum}개의 콘텐츠\n연속 재생을 선택하셨습니다.', style: TextStyle(color: Color(0xffFFFFFF),fontSize: 16.0,),),
          ],
        ),
      ),
    );
  }
}
