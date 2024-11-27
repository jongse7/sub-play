import 'package:flutter/material.dart';

import '../../contents/view/contents_screen.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../subway/view/subway_screen.dart';

class RootTab extends StatelessWidget {
  const RootTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3, // 페이지 개수
        child: BottomTapBar(),
      ),
    );
  }
}

class BottomTapBar extends StatelessWidget {
  const BottomTapBar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        children: [
          SubwayScreen(),
          ContentsScreen(),
          FavoriteScreen(),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          height: height * 0.1,
          child: TabBar(
            // Tab 상단에 Indicator 배치
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Color(0xff7266FF), // 인디케이터 색상
                width: width * 0.01, // 인디케이터 두께 (너비 증가)
              ),
              insets: EdgeInsets.only(left: width * 0.15, right: width * 0.15, bottom: height * 0.1), // 인디케이터 너비 조정
            ),
            // label color
            labelColor: Color(0xff7266FF),
            // unselected label color
            unselectedLabelColor: Color(0xff000000),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.directions_subway_outlined,
                  size: width * 0.08, // 아이콘 크기 감소
                ),
                text: '역 설정',
              ),
              Tab(
                icon: Icon(
                  Icons.play_circle_outline,
                  size: width * 0.08, // 아이콘 크기 감소
                ),
                text: '콘텐츠',
              ),
              Tab(
                icon: Icon(
                  Icons.settings_outlined,
                  size: width * 0.08, // 아이콘 크기 감소
                ),
                text: '설정',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
