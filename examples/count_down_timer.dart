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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FinalView(),
    );
  }
}

class FinalView extends StatefulWidget {
  const FinalView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration duration = (controller.duration! * controller.value);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 11),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              "Count Down Timer",
            ),
            Text(
              "@CodeWithFlexz",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.deepPurpleAccent,
                    height:
                        controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: CircularProgressIndicator(
                                      color: controller.value < 0.4821094
                                          ? Colors.deepPurpleAccent
                                          : Colors.white,
                                      backgroundColor: controller.isAnimating
                                          ? const Color.fromARGB(74, 0, 0, 0)
                                          : Colors.deepPurpleAccent,
                                      strokeWidth: 20,
                                      value: controller.value,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "0$timerString",
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: controller.value < 0.4821094
                                                ? Colors.deepPurpleAccent
                                                : Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: FloatingActionButton.extended(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          controller.isAnimating ? 10 : 20)),
                                  backgroundColor: controller.isAnimating
                                      ? Colors.white
                                      : Colors.deepPurpleAccent,
                                  onPressed: () {
                                    if (controller.isAnimating) {
                                      controller.stop();
                                    } else {
                                      controller.reverse(
                                          from: controller.value == 0.0
                                              ? 1.0
                                              : controller.value);
                                    }
                                  },
                                  icon: Icon(
                                    controller.isAnimating
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: !controller.isAnimating
                                        ? Colors.white
                                        : Colors.deepPurpleAccent,
                                  ),
                                  label: Text(
                                    controller.isAnimating ? "Pause" : "Play",
                                    style: TextStyle(
                                      color: !controller.isAnimating
                                          ? Colors.white
                                          : Colors.deepPurpleAccent,
                                    ),
                                  )),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
