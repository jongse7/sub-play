import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../const/videoList.dart';
import 'contents_loading_screen.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  int playTime = Random().nextInt(40) + 20; // 최소 20분
  int selectedCount = 0;
  int selectedRuntime = 0; // 선택된 동영상의 재생 시간 합

  List<Map<String, String>> repeatedVideoList = [];
  List<bool> selectedCards = []; // 카드 선택 상태를 저장하는 리스트

  @override
  void initState() {
    super.initState();
    repeatedVideoList = List.generate(20, (index) => videoList[index % videoList.length]); // 5개 반복해서 20개 생성
    selectedCards = List.filled(20, false); // 초기 선택 상태는 모두 false
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.025),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color(0xff7266FF), // 테두리 색상 설정
                  width: 1.0,
                ),
              ),
              child: Text(
                "재생 시간 : ${playTime}분",
                style: TextStyle(color: Color(0xff7266FF), fontSize: 18.0, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: height * 0.035),
            Expanded(
              child: ListView.builder(
                itemCount: repeatedVideoList.length, // 20개의 항목
                itemBuilder: (context, index) {
                  final video = repeatedVideoList[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // 동영상의 재생 시간 가져오기
                            String runtimeString = video["runtime"]!.replaceAll('분', '').trim();
                            List<String> timeParts = runtimeString.split(':');
                            int videoRuntime = (int.tryParse(timeParts[0]) ?? 0);

                            // 선택 상태 토글
                            if (selectedCards[index]) {
                              // 선택 해제
                              selectedCards[index] = false;
                              selectedCount--;
                              selectedRuntime -= videoRuntime;
                            } else {
                              // 선택
                              selectedCards[index] = true;
                              selectedCount++;
                              selectedRuntime += videoRuntime;
                            }
                          });
                        },
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          // 카드의 배경색을 선택 상태에 따라 변경
                          color: selectedCards[index]
                              ? Color(0xFFE1DEFF) // 선택된 카드 배경색
                              : Colors.white, // 기본 카드 배경색
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                Divider(
                                  color: Color(0xFFD9D9D9), // 회색 테두리 위
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset(
                                            video["thumbnail"]!,
                                            width: 160,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              color: Colors.black.withOpacity(0.7),
                                              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
                                              child: Text(
                                                video["runtime"]!,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              video["title"]!,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 16.0),
                                            Text(
                                              video["channel"]!,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Color(0xFFD9D9D9), // 회색 테두리 아래
                                  thickness: 0.5,
                                  height: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.15,
                      height: height * 0.05,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'asset/map/shopping.svg',
                            width: 48.0,
                            height: 48.0,
                          ),
                          if (selectedCount > 0)
                            Positioned(
                              top: 0,
                              right: width * 0.01,
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "$selectedCount",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedRuntime >= playTime
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlayLoadingScreen(contentsNum: selectedCount,)),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedRuntime >= playTime
                            ? Color(0xff7266FF) // 활성화 색상
                            : Color(0xFFD3D3D3), // 비활성화 색상
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // 둥글기 줄임
                        ),
                      ),
                      child: SizedBox(
                        width: width * 0.55,
                        child: Center(
                          child: Text(
                            '재생 시작',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
