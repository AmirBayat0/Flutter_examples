import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'page.dart';

class FinalView extends StatefulWidget {
  const FinalView({
    Key? key,
  }) : super(key: key);

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageFlipWidget(
        key: _controller,
        backgroundColor: const Color.fromARGB(232, 255, 255, 255),
        initialIndex: 0,
        lastPage: Container(
            color: Colors.white,
            child: const Center(child: Text('Last Page!'))),
        children: <Widget>[
          for (var i = 0; i < 8; i++) DemoPage(page: i),
        ],
      ),
    );
  }
}
