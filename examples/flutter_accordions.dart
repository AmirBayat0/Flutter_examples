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
//* Programming with FlexZƒ
//

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const FinalView(),
    );
  }
}

class FinalView extends StatelessWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'CodeWithFlexz',
        ),
      ),
      body: Column(
        children: const [
          Accordion(
            title: '#1 Flutter',
            content:
                'Flutter is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. First described in 2015, Flutter was released in May 2017',
          ),
          Accordion(
              title: '#2 Dart',
              content:
                  'Dart is a programming language designed for client development, such as for the web and mobile apps. It is developed by Google and can also be used to build server and desktop applications.'),
          Accordion(
              title: '#3 GetX',
              content:
                  'GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.'),
          Accordion(
              title: '#4 Python',
              content:
                  'Python is a high-level, general-purpose programming language. Its design philosophy emphasizes code readability with the use of significant indentation.'),
        ],
      ),
    );
  }
}

class Accordion extends StatefulWidget {
  final String title;
  final String content;

  const Accordion({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: isOpen ? const Color.fromARGB(255, 193, 202, 253) : Colors.white,
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(widget.title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: IconButton(
            icon: Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
          ),
        ),
        isOpen
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Text(
                  widget.content,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 34, 34, 34)),
                ),
              )
            : Container()
      ]),
    );
  }
}
