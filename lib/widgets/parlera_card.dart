// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version. As an additional permission under
// section 7, you are allowed to distribute the software through an app
// store, even if that store has restrictive terms and conditions that
// are incompatible with the AGPL, provided that the source is also
// available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ParleraCard extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final double? height;

  const ParleraCard(
      {Key? key, required this.child, required this.onTap, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        scaleFactor: 0.75,
        onTap: () {},
        child: Ink(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: child,
            )));
  }
}
