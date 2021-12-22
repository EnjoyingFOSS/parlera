import 'package:flutter/material.dart';
import 'package:parlera/widgets/parlera_card.dart';

class ParleraListItem extends StatelessWidget {
  const ParleraListItem(
      {Key? key,
      required this.leading,
      required this.title,
      required this.onTap})
      : super(key: key);

  final Widget leading;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final margin = 24.0;
    final iconSize = 48;
    return ParleraCard(
        height: 80,
        child: Stack(children: [
          Positioned.directional(
              textDirection: direction,
              start: margin,
              top: margin,
              child: leading),
          Positioned.directional(
              textDirection: direction,
              start: margin + iconSize,
              top: margin,
              child: Text(title, style: Theme.of(context).textTheme.headline5))
        ]), //todo make translatable
        onTap: onTap);
  }
}
