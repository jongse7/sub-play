import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../const/videoList.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;
  bool _isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationCompleted = true;
        });
      }
    });

    _positionAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.linear,
        ));

    _animationController.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final defaultTextStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: Color(0xff6246E5),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SubwayArea(
                        width: width,
                        defaultTextStyle: defaultTextStyle,
                        animationController: _animationController,
                        positionAnimation: _positionAnimation,
                      ),
                    ),
                    VideoPlayer(),
                    const TitleWidget(),
                    const ChannelWidget(),
                    const SubTitleWidget(),
                    RecommendArea(),
                    CommentArea(),
                  ],
                ),
              ),
            ),
            if (_isAnimationCompleted)
              Stack(
                children: [
                  // 검은색 반투명 배경
                  Container(
                    color: Colors.black.withOpacity(0.8),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('asset/map/bell.png'),
                        SizedBox(height: 24),
                        Text(
                          '콘텐츠가 종료되었습니다 😊\n하차 준비를 해주세요!\n하차 방향은 오른쪽입니다.',
                          textAlign: TextAlign.center, // 텍스트 가운데 정렬
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 형광 효과 추가
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width * 0.05, // 화면 오른쪽 절반 차지
                        height: height * 0.35,
                        child: GlowEffectWidget(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class GlowEffectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.0), // 좌측 상단에 곡선
          bottomLeft: Radius.circular(45.0), // 좌측 하단에 곡선
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff836CF0).withOpacity(0.1),
            Color(0xff836CF0).withOpacity(0.3), // 끝 색상 투명도 증가
          ],
          stops: [0.0, 1.0], // 그라데이션의 위치 설정 (조금 더 넓게)
        ),
      ),
    );
  }
}

class SubwayArea extends StatelessWidget {
  final double width;
  final TextStyle defaultTextStyle;
  final AnimationController animationController;
  final Animation<double> positionAnimation;

  const SubwayArea({
    Key? key,
    required this.width,
    required this.defaultTextStyle,
    required this.animationController,
    required this.positionAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffD6CEFD),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SizedBox(
                height: 20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 8,
                      child: Container(
                        width: width,
                        height: 1,
                        color: Color(0xff6246E5),
                      ),
                    ),
                    Positioned(
                      left: width * 0.15 - 4,
                      top: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xff6246E5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: width * 0.45,
                      top: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xff6246E5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: width * 0.76,
                      top: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xff6246E5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: positionAnimation.value * (width - 30),
                      child: Image.asset('asset/map/subway_icon.png'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('이전역',
                        style: defaultTextStyle, textAlign: TextAlign.center),
                    Text('이수역[7호선]',
                        style: defaultTextStyle.copyWith(color: Colors.black),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('현재역',
                        style: defaultTextStyle, textAlign: TextAlign.center),
                    Text('남성역[7호선]',
                        style: defaultTextStyle.copyWith(color: Colors.black),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('다음역',
                        style: defaultTextStyle, textAlign: TextAlign.center),
                    Text('숭실대입구역[7호선]',
                        style: defaultTextStyle.copyWith(color: Colors.black),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class VideoPlayer extends StatelessWidget {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
        Uri.parse('https://www.youtube-nocookie.com/embed/V8chp43s5_0'));

  VideoPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: WebViewWidget(controller: controller),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        '언니 조심스럽게 다가갈게요 ^^ | 살롱드립 가비',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}

class ChannelWidget extends StatelessWidget {
  const ChannelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEO 테오',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '구독자 13.6만명',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: Color(0xffF0F0F0),
        height: 80.0,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Text(
            '조회수 946,691회  최초 공개: 2024. 11. 19.\n(엄청난 에너지로 등장하는 효과음) 퀸가비 is oming 😉',
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class RecommendArea extends StatelessWidget {
  RecommendArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '비슷한 러닝타임 콘텐츠 추천',
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      videoList[index]['thumbnail']!,
                      width: 160,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommentArea extends StatelessWidget {
  const CommentArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '댓글 2,453개',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '댓글 추가...',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // 선 색상 설정
                      thickness: 1.0, // 선 두께 설정
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
