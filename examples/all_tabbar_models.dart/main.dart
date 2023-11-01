import 'package:flutter/material.dart';
import 'package:insta_project/all_tab_models.dart/constants.dart';

import 'indicators.dart';

//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter All TabBar Models',
      theme: ThemeData(useMaterial3: true),
      home: const FinalView(),
    );
  }
}

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView>
    with SingleTickerProviderStateMixin {
  /// Tab Controller
  late TabController _tabController;

  /// Tab Titles
  final List<Tab> _tabs = const [
    Tab(text: 'Tab1'),
    Tab(text: 'Tab2'),
    Tab(text: 'Tab3'),
  ];

  /// Tab Icons
  final List<Tab> _iconTabs = const [
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.search)),
    Tab(icon: Icon(Icons.settings)),
  ];

  /// Tab Icons and Title
  final List<Tab> _titleAndIconTabs = const [
    Tab(
      icon: Icon(Icons.home),
      iconMargin: EdgeInsets.only(top: 2),
      text: "Tab1",
    ),
    Tab(
      icon: Icon(Icons.search),
      iconMargin: EdgeInsets.only(top: 2),
      text: "Tab2",
    ),
    Tab(
      icon: Icon(Icons.settings),
      iconMargin: EdgeInsets.only(top: 2),
      text: "Tab3",
    ),
  ];

  /// Tabs Body
  final List<Widget> _bodyTabs = [
    const ReuseableAppBodyWidget(
      icon: Icons.home,
      title: 'Tab1',
    ),
    const ReuseableAppBodyWidget(
      icon: Icons.search,
      title: 'Tab2',
    ),
    const ReuseableAppBodyWidget(
      icon: Icons.settings,
      title: 'Tab3',
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: selectedColor,
        centerTitle: true,
        title: const Text(
          "All TabBar Models",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // *=> 1
                    TabBar(
                      controller: _tabController,
                      tabs: _tabs,
                      labelColor: selectedColor,
                      indicatorColor: selectedColor,
                      unselectedLabelColor: unselectedColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),

                    // *=> 2
                    TabBar(
                      controller: _tabController,
                      tabs: _tabs,
                      labelColor: selectedColor,
                      indicatorColor: selectedColor,
                      unselectedLabelColor: unselectedColor,
                      indicatorSize: TabBarIndicatorSize.label,
                    ),

                    // *=> 3
                    TabBar(
                      controller: _tabController,
                      labelColor: selectedColor,
                      unselectedLabelColor: unselectedColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const MaterialDesignIndicator(
                        indicatorHeight: 4,
                        indicatorColor: selectedColor,
                      ),
                      tabs: _tabs,
                    ),

                    // *=> 4
                    TabBar(
                      controller: _tabController,
                      tabs: _iconTabs,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.black,
                      labelColor: selectedColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        color: selectedColor.withOpacity(0.2),
                      ),
                    ),

                    // *=> 5
                    TabBar(
                      controller: _tabController,
                      tabs: _tabs,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.black,
                      labelColor: selectedColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: selectedColor.withOpacity(0.2),
                      ),
                    ),

                    // *=> 6
                    Container(
                      height: kToolbarHeight - 8.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedColor),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: _tabs,
                      ),
                    ),

                    // *=> 7
                    Container(
                      height: kToolbarHeight - 8.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedColor),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: _titleAndIconTabs,
                      ),
                    ),

                    // *=> 8
                    Container(
                      height: kToolbarHeight + 8.0,
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 16.0, left: 16.0),
                      decoration: const BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            color: Colors.white),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        tabs: _tabs,
                      ),
                    ),
                  ]
                      .map(
                        (item) => Column(
                          children: [
                            item,
                            const Divider(
                              color: Colors.transparent,
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: TabBarView(
                  controller: _tabController,
                  children: _bodyTabs,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableAppBodyWidget extends StatelessWidget {
  const ReuseableAppBodyWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: selectedColor,
          ),
          Text(
            "$title contents\nlike image, info or...",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: selectedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
