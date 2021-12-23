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
    return Ink(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: InkWell(onTap: onTap, child: child));
  }
}
