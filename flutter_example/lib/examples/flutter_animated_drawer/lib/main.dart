import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

/////////////////////////////////
// 🔥 CodeWithFlexz on Instagram

// 🚀 AmirBayat0 on Github
// 👽 Programming with Flexz on Youtube
////////////////////////////////

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animated Drawer',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: const HomeTest(),
    );
  }
}

class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  final zoomDrawerController = ZoomDrawerController();
  List<String> screenStringTest = ["Home", "Explore", "Profile", "Settings"];
  List<IconData> screenIconTest = [
    Icons.apps,
    Icons.search,
    Icons.person,
    Icons.settings
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuBackgroundColor: Colors.white,
      shadowLayer1Color: const Color.fromARGB(255, 245, 245, 245),
      shadowLayer2Color:
          const Color.fromARGB(255, 230, 230, 230).withOpacity(0.3),
      menuScreen: _menuScreen(context),
      borderRadius: 50.0,
      showShadow: true,
      // moveMenuScreen: false,
      // isRtl: true,
      // angle: -5.0,
      angle: -16.0,
      // angle: 0,
      drawerShadowsBackgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      mainScreen: _mainScreen(context),
    );
  }

  Container _menuScreen(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                zoomDrawerController.toggle?.call();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "User Name",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("${screenStringTest[index]} Tapped");
                        },
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          leading: Icon(
                            screenIconTest[index],
                            color: Theme.of(context).primaryColor,
                            size: 27,
                          ),
                          title: Text(
                            screenStringTest[index],
                            style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 70),
                  child: TextButton.icon(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor.withOpacity(0.5)),
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Scaffold _mainScreen(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Flutter Animated Drawer"),
        leading: IconButton(
          onPressed: () => zoomDrawerController.toggle?.call(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              screenStringTest[selectedIndex],
              style: TextStyle(
                fontSize: 50.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            Icon(
              screenIconTest[selectedIndex],
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {},
          child: const Icon(
            Icons.adb_rounded,
            size: 30.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).primaryColor,
          selectedFontSize: 14.0,
          selectedIconTheme: const IconThemeData(size: 28.0),
          unselectedIconTheme:
              IconThemeData(size: 25.0, color: Colors.grey[500]),
          showUnselectedLabels: false,
          showSelectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}
