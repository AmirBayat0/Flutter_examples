import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Cart",
          style: Theme.of(context).textTheme.headline1,
        ),
        const Icon(
          IconlyLight.wallet,
          size: 40,
        ),
      ],
    );
  }
}