import 'package:flutter/material.dart';

class ParleraCard extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final double? height;

  const ParleraCard(
      {Key? key, required this.child, required this.onTap, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
              // border: Border.all(
              //     width: 2,
              //     color: Theme.of(context).colorScheme.onBackground)
            ),
            child: child));
  }
}
