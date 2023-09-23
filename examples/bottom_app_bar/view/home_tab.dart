import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HomeTab  extends StatelessWidget {
  const HomeTab ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Home",
          style: Theme.of(context).textTheme.headline1,
        ),
        const Icon(
          IconlyLight.home,
          size: 40,
        ),
      ],
    );
  }
}