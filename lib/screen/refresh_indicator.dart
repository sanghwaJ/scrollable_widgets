import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

import '../layout/main_layout.dart';

class RefreshIndicatorScreen extends StatelessWidget {
  final List<int> numbers = List.generate(
    100,
    (index) => index,
  );

  RefreshIndicatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'RefreshIndicatorScreen',
      // 리스트를 위로 당기는 순간, 새로고침
      body: RefreshIndicator(
        onRefresh: () async {
          // 서버 요청
          await Future.delayed(Duration(seconds: 3));
        },
        child: ListView(
          children: numbers
              .map(
                (e) => renderContainer(
                    color: rainbowColors[e % rainbowColors.length], index: e),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);

    return Container(
      // ReorderableListView에서 사용되는 container와 다르다는 것을 인식시키기 위해 key 사용
      key: Key(index.toString()),
      height: height == null ? 300 : height, // height ?? 300 과 같음
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
