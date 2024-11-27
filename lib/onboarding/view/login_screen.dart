import 'package:flutter/material.dart';
import 'package:sub_play/favorite/view/favorite_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isFormValid {
    return _idController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final defaultTextStyle = TextStyle(
      fontSize: 13.5,
      color: Color(0xff8F8F8F),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.11),
          Text(
            'SUBPLAY',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
              color: Color(0xff7266FF),
            ),
          ),
          SizedBox(height: height * 0.025),
          CustomTextField(
            controller: _idController,
            hintText: '아이디',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
            onChanged: _updateState, // 실시간 반영
          ),
          CustomTextField(
            controller: _passwordController,
            hintText: '비밀번호',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            onChanged: _updateState, // 실시간 반영
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: GestureDetector(
              onTap: _isFormValid
                  ? () {
                // 로그인 버튼 클릭 시 RootTab으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              }
                  : null,
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: _isFormValid
                      ? Color(0xff7266FF) // 활성화 상태 배경색
                      : Color(0xFFD3D3D3), // 비활성화 상태 배경색
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  '로그인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('비밀번호 찾기   | ', style: defaultTextStyle),
              Text('  아이디 찾기   | ', style: defaultTextStyle),
              Text('  회원가입', style: defaultTextStyle.copyWith(color: Color(0xff6554BA))),
            ],
          ),
        ],
      ),
    );
  }

  void _updateState(String value) {
    setState(() {}); // 상태를 갱신하여 화면 업데이트
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final BorderRadius borderRadius;
  final double topBorderWidth;
  final double bottomBorderWidth;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.borderRadius,
    required this.controller,
    required this.onChanged,
    this.topBorderWidth = 0.5,
    this.bottomBorderWidth = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // 입력값 변경 시 호출
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: Color(0xFFB4B4B4),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: Color(0xFFB4B4B4),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: Color(0xFFB4B4B4),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
