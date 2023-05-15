import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  // 최대 높이
  @override
  double get maxExtent => maxHeight;

  // 최소 높이
  @override
  double get minExtent => minHeight;

  // shouldRebuild => 새로 빌드를 해야할지 말지 결정하는 메소드 (true => build 재실행, false => build 재실행 안함)
  @override
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    // covariant SliverPersistentHeaderDelegate => SliverPersistentHeaderDelegate를 상속한 클래스도 사용 가능
    // oldDelegate => build가 실행됐을 때, 이전 Delegate
    // this => newDelegate
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // slivers 안에서 List 형태의 위젯들을 사용할 수 있음 (이름은 Sliver~~로 되어있음)
        slivers: [
          renderSliverAppBar(),
          renderHeader(),
          renderBuilderSliverList(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderBuilderSliverList(),
        ],
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

  Widget testListView() {
    return Column(
      children: [
        // 모든 ListView는 Column 아래에 있을 때, Expanded로 감싸주어야 함 (ListView의 default height는 무한이기 때문)
        Expanded(
          child: ListView(
            children: rainbowColors
                .map(
                  (e) => renderContainer(
                    color: e,
                    index: 1,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  /**
   * ListView & GridView
   */
  // 1) ListView 기본 생성자와 유사
  SliverList renderChildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        numbers
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

  // 2) ListView.builder 생성자와 유사
  SliverList renderBuilderSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 100,
      ),
    );
  }

  // 3) GridView.count와 유사
  SliverGrid renderChildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  // 4) GridView.builder와 유사
  SliverGrid renderSliverGridBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 100,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }

  /**
   * AppBar
   */
  SliverAppBar renderSliverAppBar() {
    // SliverAppBar => iOS는 스크롤 가능, Android는 스크롤 불가
    // SliverAppBar를 사용하면 AppBar도 리스트의 일부가 됨
    return SliverAppBar(
      floating: true, // floating: true => 스크롤을 위로 올리면, 리스트의 중간에도 AppBar가 나타남
      pinned: false, // pinned: true => 스크롤을 움직여도 AppBar가 고정되어있음
      snap: true, // snap: true => AppBar 자석 효과 (floating: true에만 사용 가능)
      stretch: true, // stretch: true => 맨 위에서 스크롤을 위로 당겼을 때, AppBar가 늘어남
      expandedHeight: 200, // AppBar의 최대 높이
      collapsedHeight: 100, // AppBar의 최소 높이
      // AppBar에서 크기에 따라 나타나고 사라지는 구간
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
        title: Text('FlexibleSpace'),
      ),
      title: Text('CustomScrollViewScreen'),
    );
  }

  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true, // pinned: true => 스크롤 할 때마다 헤더를 쌓아 올림
      delegate: _SliverFixedHeaderDelegate(
        minHeight: 75,
        maxHeight: 150,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              '신기하네~',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
