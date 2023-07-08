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

import 'package:flutter/rendering.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  final _halfWavelength = 12;
  final _halfPeak = 8;

  @override
  getClip(Size size) {
    final path = Path();

    final y = size.height - _halfPeak / 2;

    path.lineTo(0, y);

    var x = 0.0;
    int multiplier = -1;
    while (x < size.width) {
      x += _halfWavelength;
      path.quadraticBezierTo(
          x - _halfWavelength / 2, y + _halfPeak * multiplier, x, y);
      multiplier *= -1;
    }

    path.lineTo(x, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BottomWaveClipper oldClipper) {
    return false;
  }
}
