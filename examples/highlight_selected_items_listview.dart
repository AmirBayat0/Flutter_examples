import 'package:flutter/cupertino.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
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

class _FinalViewState extends State<FinalView> {
  List<Map> data = List.generate(
    31,
    (index) => {'id': index, 'name': 'Item $index', 'isSelected': false},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            data = List.generate(
              31,
              (index) =>
                  {'id': index, 'name': 'Item $index', 'isSelected': false},
            );
          });
        },
        child: const Icon(CupertinoIcons.delete_solid),
      ),
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('C O D E  W I T H  F L E X Z'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, index) {
              return Card(
                key: ValueKey(data[index]['name']),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: data[index]['isSelected'] == true
                    ? Colors.green[600]
                    : Colors.white,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      data[index]['isSelected'] = !data[index]['isSelected'];
                    });
                  },
                  leading: CircleAvatar(
                      backgroundColor: data[index]['isSelected'] == true
                          ? Colors.white
                          : Colors.green,
                      child: Text(
                        data[index]['id'].toString(),
                        style: TextStyle(
                            color: data[index]['isSelected'] == true
                                ? Colors.green[600]
                                : Colors.white),
                      )),
                  title: Text(
                    data[index]['name'],
                    style: TextStyle(
                        color: data[index]['isSelected'] == true
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
