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
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  bool _sortAscending = true;

  final List<Map<String, dynamic>> _products = [
    {'id': 1, 'name': 'Apple Air Tag', 'price': 19.99},
    {'id': 2, 'name': 'Fire Tv Stick', 'price': 15.99},
    {'id': 3, 'name': 'Wireless microscope', 'price': 12.99},
    {'id': 4, 'name': 'Lash Princess', 'price': 24.99},
    {'id': 5, 'name': 'Travel Bag', 'price': 17.99},
    {'id': 6, 'name': 'AirBuds', 'price': 35.99},
  ];

  void _sortProducts(bool ascending) {
    setState(() {
      _sortAscending = ascending;
      _products.sort((a, b) => ascending
          ? a['price'].compareTo(b['price'])
          : b['price'].compareTo(a['price']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        title: const Text('CodeWithFlexz'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 29, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _sortAscending ? 'Price Low to High' : 'Price High to Low',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _sortProducts(!_sortAscending),
                  child: Row(
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent),
                      ),
                      Icon(
                          _sortAscending
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: Colors.indigoAccent),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                // the list item - product
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin:
                          const EdgeInsets.only(bottom: 3, left: 3, right: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_products[index]['id']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_products[index]['name']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '\$${_products[index]['price']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
