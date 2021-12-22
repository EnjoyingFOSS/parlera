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
//
// This file is derived from work covered by the following license notice:
//
//   MIT License
//
//   Copyright (c) 2019 Korniienko Vladyslav
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//   of this software and associated documentation files (the "Software"), to deal
//   in the Software without restriction, including without limitation the rights
//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//   copies of the Software, and to permit persons to whom the Software is
//   furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in all
//   copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//   SOFTWARE.

import 'dart:math';

import 'package:flutter/material.dart';

class ConcentricClipper extends CustomClipper<Path> {
  final double radius;
  final double limit = 0.5;
  final double verticalPosition;
  final double progress;
  final double growFactor;
  final bool reverse;

  ConcentricClipper({
    this.progress = 0.0,
    this.verticalPosition = 0.85,
    this.radius = 30.0,
    this.growFactor = 30.0,
    this.reverse = false,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    Rect shape;
    path.fillType = PathFillType.evenOdd;
    if (progress <= limit) {
      shape = _createGrowingShape(path, size);
    } else {
      shape = _createShrinkingShape(path, size);
    }
    path.addArc(shape, 0, 90);
    // path.addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(ConcentricClipper oldClipper) {
    return progress != oldClipper.progress;
  }

  Rect _createGrowingShape(Path path, Size size) {
    double _progress = progress * growFactor;
    double _limit = limit * growFactor;
    double r = radius + pow(2, _progress);
    double delta = (1 - _progress / _limit) * radius;
    double x = (size.width / 2) + r - delta;
    double y = (size.height * verticalPosition) + radius;

    if (reverse) {
      x *= -1;
    }
    return Rect.fromCircle(center: Offset(x, y), radius: r);
  }

  Rect _createShrinkingShape(Path path, Size size) {
    double _progress = (progress - limit) * growFactor;
    double _limit = limit * growFactor;
    double r = radius + pow(2, _limit - _progress);
    double delta = _progress / _limit * radius;
    double x = size.width / 2 - r + delta;
    double y = (size.height * verticalPosition) + radius;

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    if (reverse) {
      x *= -1;
    }
    return Rect.fromCircle(center: Offset(x, y), radius: r);
  }
}
