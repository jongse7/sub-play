import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sub_play/subway/const/mockStations.dart';

import '../../play/view/recommend_screen.dart';

class SubwayScreen extends StatefulWidget {
  const SubwayScreen({Key? key}) : super(key: key);

  @override
  _SubwayScreenState createState() => _SubwayScreenState();
}

class _SubwayScreenState extends State<SubwayScreen> {

  String startStation = '';
  String endStation = '';

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  List<String> filteredStartStations = [];
  List<String> filteredEndStations = [];

  final GlobalKey startFieldKey = GlobalKey();
  final GlobalKey endFieldKey = GlobalKey();

  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    filteredStartStations = List.from(mockStations);
    filteredEndStations = List.from(mockStations);

    startController.addListener(() {
      _filterStations(startController, true);
    });

    endController.addListener(() {
      _filterStations(endController, false);
    });
  }

  void _filterStations(TextEditingController controller, bool isStart) {
    setState(() {
      final query = controller.text.trim();
      if (isStart) {
        filteredStartStations =
            mockStations.where((station) => station.contains(query)).toList();
      } else {
        filteredEndStations =
            mockStations.where((station) => station.contains(query)).toList();
      }
    });
    _showOverlay(isStart);
  }

  void _showOverlay(bool isStart) {
    _removeOverlay();

    final RenderBox? renderBox = isStart
        ? startFieldKey.currentContext?.findRenderObject() as RenderBox?
        : endFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              color: Color(0xFFF5F5F5),
              child: ListView.builder(
                itemCount: isStart
                    ? filteredStartStations.length
                    : filteredEndStations.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final station = isStart
                      ? filteredStartStations[index]
                      : filteredEndStations[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          station,
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            if (isStart) {
                              startStation = station;
                              startController.text = station;
                            } else {
                              endStation = station;
                              endController.text = station;
                            }
                          });
                          _removeOverlay();
                        },
                      ),
                      Divider(
                        color: Color(0xFFD9D9D9),
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  void _removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void _resetFields() {
    setState(() {
      startController.clear();
      endController.clear();
      startStation = '';
      endStation = '';
    });
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final isResetEnabled =
        startController.text.isNotEmpty || endController.text.isNotEmpty;
    final isRecommendEnabled =
        startController.text.isNotEmpty && endController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // 포커스 해제
            _removeOverlay(); // 오버레이 제거
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.swap_vert_sharp,
                            color: Colors.black, size: 32.0),
                        onTap: () {
                          setState(() {
                            final temp = startStation;
                            startStation = endStation;
                            endStation = temp;

                            startController.text = startStation;
                            endController.text = endStation;
                          });
                        },
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSearchField(
                              key: startFieldKey,
                              controller: startController,
                              hintText: '출발역 입력',
                              leftIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.asset(
                                  'asset/map/cursor.svg',
                                  width: 16.0,
                                  height: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              onFocusChanged: (isFocused) {
                                if (!isFocused) _removeOverlay();
                              },
                            ),
                            buildSearchField(
                              key: endFieldKey,
                              controller: endController,
                              hintText: '도착역 입력',
                              leftIcon: Icon(Icons.location_on_sharp,
                                  color: Color(0xffFF0000)),
                              onFocusChanged: (isFocused) {
                                if (!isFocused) _removeOverlay();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015),
                Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: SizedBox(
                    width: screenWidth * 0.225,
                    height: height * 0.038,
                    child: TextButton(
                      onPressed: isResetEnabled ? _resetFields : null,
                      style: TextButton.styleFrom(
                        backgroundColor: isResetEnabled
                            ? Color(0xff7266FF)
                            : Color(0xFFD9D9D9),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '다시 입력',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                ClipRect(
                  child: SizedBox(
                    width: screenWidth,
                    height: height * 0.6,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset('asset/map/subway.png'),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: isRecommendEnabled
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecommendScreen()),
                      );
                    }
                        : null,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isRecommendEnabled
                            ? Color(0xff7266FF)
                            : Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '추천 콘텐츠 확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchField({
    required Key key,
    required TextEditingController controller,
    required String hintText,
    required Widget leftIcon,
    required ValueChanged<bool> onFocusChanged,
  }) {
    return Focus(
      key: key,
      onFocusChange: onFocusChanged,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          border: Border.all(
            color: Color(0xFF000000),
            width: 1.0,
          ),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: leftIcon,
            suffixIcon:
            Icon(Icons.search_outlined, color: Color(0xffC0C0C0), size: 32),
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ),
    );
  }
}
