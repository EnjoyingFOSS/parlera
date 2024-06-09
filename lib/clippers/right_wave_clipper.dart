// Copyright Miroslav Mazel
//
// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// As an additional permission under section 7, you are allowed to distribute
// the software through an app store, even if that store has restrictive terms
// and conditions that are incompatible with the AGPL, provided that the source
// is also available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// As a limitation under section 7, all unofficial builds and forks of the app
// must be clearly labeled as unofficial in the app's name (e.g. "Parlera
// UNOFFICIAL", never just "Parlera") or use a different name altogether.
// If any code changes are made, the fork should use a completely different name
// and app icon. All unofficial builds and forks MUST use a different
// application ID, in order to not conflict with a potential official release.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/rendering.dart';

class RightWaveClipper extends CustomClipper<Path> {
  final _halfWavelength = 12;
  final _halfPeak = 8;

  @override
  Path getClip(Size size) {
    final path = Path();

    final x = size.width - _halfPeak / 2;

    path.lineTo(x, 0);

    var y = 0.0;
    int multiplier = -1;
    while (y < size.height) {
      y += _halfWavelength;
      path.quadraticBezierTo(
          x + _halfPeak * multiplier, y - _halfWavelength / 2, x, y);
      multiplier *= -1;
    }

    path
      ..lineTo(0, y)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(RightWaveClipper oldClipper) {
    return false;
  }
}
