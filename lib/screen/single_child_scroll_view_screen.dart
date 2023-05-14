import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  // List.generate => 리스트 생성 함수
  final List<int> numbers = List.generate(
    100,
    (index) => index,
  );

  SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'SingleChildScrollView',
      // SingleChildScrollView는 모든 위젯을 한 번에 다 가져오기 때문에 비효율적
      body: renderPerformance(),
    );
  }

  Widget renderContainer({
    required Color color,
    int? index,
  }) {
    if (index != null) {
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }

  // 1) 기본 렌더링
  Widget renderSimple() {
    // SingleChildScrollView => 위젯이 화면을 넘어가지 않으면 Scroll 불가, 화면을 넘어가면 Scroll 가능 (default)
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(
                color: e,
              ),
            )
            .toList(),
      ),
    );
  }

  // 2) AlwaysScrollableScrollPhysics
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      // NeverScrollableScrollPhysics() => 스크롤 불가
      // AlwaysScrollableScrollPhysics => 위젯이 화면을 넘지 않아도 강제로 스크롤이 되도록 함
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  // 3) 위젯이 화면에서 잘리지 않게 하기
  Widget renderClip() {
    return SingleChildScrollView(
      // clipBehavior => 위젯이 화면에서 잘렸을 때 실행
      // Clip.none => 위젯이 화면에서 잘리지 않도록 함
      clipBehavior: Clip.none,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  // 4) 여러가지 physics 정리
  Widget renderPhysics() {
    return SingleChildScrollView(
      // NeverScrollableScrollPhysics() => 스크롤 불가
      // AlwaysScrollableScrollPhysics => 위젯이 화면을 넘지 않아도 강제로 스크롤이 되도록 함
      // BouncingScrollPhysics => 스크롤 시, 튕김 효과를 줌 (iOS 스크롤 default, Android에 튕김 효과 적용이 필요한 경우 사용)
      // ClampingScrollPhysics => 튕김 효과 X (Android 스크롤 default)
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(
                color: e,
              ),
            )
            .toList(),
      ),
    );
  }

  // 5) SingleChildScrollView의 퍼포먼스
  Widget renderPerformance() {
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
