import 'package:flutter/material.dart';

class ChangeStatusQuantity extends StatelessWidget {
  const ChangeStatusQuantity({
    Key? key,
    required this.quantity,
    required this.add,
    required this.minus,
    required this.iconSize,
  }) : super(key: key);

  final int quantity;
  final VoidCallback add;
  final VoidCallback minus;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: minus,
                child: Center(
                  child: Icon(
                    Icons.remove,
                    size: iconSize,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            quantity.toString(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: GestureDetector(
              onTap: add,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
