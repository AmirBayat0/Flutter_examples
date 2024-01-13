import 'package:flutter/material.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomScrollingWidget(),
    );
  }
}

class CustomScrollingWidget extends StatefulWidget {
  const CustomScrollingWidget({Key? key}) : super(key: key);

  @override
  State createState() => _CustomScrollingWidgetState();
}

class _CustomScrollingWidgetState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// Sliver App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            backgroundColor: const Color.fromARGB(255, 1, 1, 68),
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Flutter is 🔥"),
              background: Image.network(
                'https://www.manchesterdigital.com/storage/13254/flutter-3.png',
                fit: BoxFit.cover,
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: Colors.tealAccent,
              alignment: Alignment.center,
              height: 180,
              child: const Text(
                'This is the first PlaceHolder',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),

          /// Sliver Grid
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('Category Item $index'),
                );
              },
              childCount: 21,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.deepPurpleAccent,
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'This is the second PlaceHolder',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 120.0,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Card(
                            color: Colors.cyan[100 * (index % 9)],
                            child: Image.network(
                              'https://blog.logrocket.com/wp-content/uploads/2021/04/Building-Flutter-desktop-app-tutorial-examples.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Flutter $index')
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              childCount: 10,
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightGreen[100 * (index % 12)],
                  child: Text('Featured Item - Number $index'),
                );
              },
            ),
          ),

          /// Sliver Grid
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 70.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.amber[100 * (index % 9)],
                  child: Text('PI $index'),
                );
              },
              childCount: 40,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.deepOrangeAccent,
              alignment: Alignment.center,
              height: 80,
              child: const Text(
                'This is the Footer',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
