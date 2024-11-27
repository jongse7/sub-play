import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome 사용
import 'package:sub_play/onboarding/view/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드(Portrait)로 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard', // 폰트 설정
      ),
      home: SplashScreen(),
    ),
  );
}