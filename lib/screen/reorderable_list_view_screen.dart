import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({Key? key}) : super(key: key);

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ReorderableListViewScreen',
      body: renderReorderableListViewBuild(),
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

  // 1) ReorderableListView 한 번에 다 가져오기
  Widget renderDefault() {
    return ReorderableListView(
      children: numbers
          .map(
            (e) => renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
          )
          .toList(),
      // onReorder => 위젯의 순서를 바꾸면 실행
      // onReorder의 index는 값을 옮기기 전 상태에서 판별
      // [red, green, yellow]에서 red를 yellow 뒤로 옮기는 경우, red의 oldIndex는 0, newIndex는 3
      // [red, green, yellow]에서 yellow를 red 앞으로 옮기는 경우, yellow의 oldIndex는 2, newIndex는 0
      // 따라서, oldIndex가 newIndex보다 작은 경우 newIndex는 -1처리, oldIndex가 newIndex보다 큰 경우 newIndex는 그대로
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
    );
  }

  // 2) builder => 화면에 보이는 위젯만 가져와 메모리를 효율적으로 사용할 수 있음
  Widget renderReorderableListViewBuild() {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[numbers[index] % rainbowColors.length],
          index: numbers[index],
        );
      },
      itemCount: numbers.length,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
    );
  }
}
