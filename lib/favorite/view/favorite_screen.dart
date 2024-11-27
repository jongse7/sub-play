import 'package:flutter/material.dart';

import '../../subway/view/subway_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final List<String> topics = [
    '코미디', '드라마', '예능', '애니메이션', '노래', '시사', '아이돌', '미스터리',
    '힐링물', '괴물쥐', '유학생', '요리', '흑백요리사', '추리', '코믹스', '디즈니', 'SF', '게임', '리그오브레전드'
  ];
  final Set<String> selectedTopics = {};
  bool isFirstStep = true;

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                // Custom Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '주제 설정 ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: isFirstStep ? '1' : '2',
                              style: TextStyle(
                                color: Color(0xff7266FF),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: '/2',
                              style: TextStyle(
                                color: Color(0xff8A8A8A),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress Indicator Line with Animation
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: Color(0xffE0E0E0), // 회색 선
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width *
                              _progressAnimation.value,
                          color: Color(0xff7266FF), // 보라색 채워진 부분
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    isFirstStep ? '어떤 주제를 좋아하시나요?' : '어떤 주제를 싫어하시나요?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '주제 기반으로 콘텐츠를 추천해드립니다.',
                    style: TextStyle(fontSize: 13, color: Color(0xff8A8A8A)),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: topics.map((topic) {
                        final bool isSelected = selectedTopics.contains(topic);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTopics.remove(topic);
                              } else {
                                selectedTopics.add(topic);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: isSelected
                                    ? Color(0xff7266FF)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                color: isSelected
                                    ? Color(0xff7266FF)
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Positioned Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isFirstStep) {
                    // 첫 번째 단계에서는 두 번째 단계로 이동
                    setState(() {
                      isFirstStep = false;
                      selectedTopics.clear(); // 선택한 주제를 초기화
                      _animationController.forward();
                    });
                  } else {
                    // 두 번째 단계에서는 SubwayScreen으로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SubwayScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff7266FF), // 배경색
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  isFirstStep ? '다음' : '저장',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
