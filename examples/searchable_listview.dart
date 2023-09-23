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
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeWithFlexz'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(CupertinoPageRoute(builder: (_) => const SearchPage())),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please Click on the Search Icon in AppBar or Tab on The Below Icon",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            CircleAvatar(
              radius: 25,
              child: Center(
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const Icon(
                    Icons.search,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  final List<Map<String, dynamic>> allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Cavers", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  List<Map<String, dynamic>> foundUsers = [];
  @override
  initState() {
    foundUsers = allUsers;
    super.initState();
  }

  void filter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            onChanged: (value) => filter(value),
            controller: textEditingController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      textEditingController.clear();
                      foundUsers = allUsers;
                    });
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: foundUsers.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          "Recent",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )),
                  Expanded(
                      flex: 20,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: foundUsers.length,
                        itemBuilder: (context, index) => Card(
                          key: ValueKey(foundUsers[index]["id"]),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                              leading: Text(
                                foundUsers[index]["id"].toString(),
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(foundUsers[index]['name']),
                              subtitle: Text(
                                  '${foundUsers[index]["age"].toString()} years old'),
                              trailing: const Icon(
                                Icons.call,
                                color: Colors.green,
                              )),
                        ),
                      )),
                ],
              )
            : const Center(
                child: Text(
                  'No results found',
                ),
              ),
      ),
    );
  }
}
