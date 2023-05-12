import 'package:flutter/material.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  const SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'SingleChildScrollView',
        body: SingleChildScrollView(
          child: Column(
            children: [
              renderContainer(color: Colors.red),
            ],
          ),
        ));
  }

  Widget renderContainer({
    required Color color,
  }) {
    return Container(
      height: 300,
      color: color,
    );
  }
}
