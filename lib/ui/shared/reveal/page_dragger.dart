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
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and "ewaosie"
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool? canDragLeftToRight;
  final bool? canDragRightToLeft;
  final StreamController<SlideUpdate>? slideUpdateStream;

  const PageDragger({Key? key, 
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
  }) : super(key: key);

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const fullTransitionPx = 300.0;

  Offset? dragStart;
  SlideDirection? slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart!.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft!) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight!) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / fullTransitionPx).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream!.add(
          SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream!.add(SlideUpdate(
      UpdateType.doneDragging,
      SlideDirection.none,
      0.0,
    ));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPageDragger {
  static const percentPerMillisecond = 0.005;

  final SlideDirection? slideDirection;
  final TransitionGoal? transitionGoal;

  late AnimationController completionAnimationController;

  AnimatedPageDragger({
    required this.slideDirection,
    required this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate>? slideUpdateStream,
    required TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;

    late double endSlidePercent;
    late Duration duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = Duration(
          milliseconds: (slideRemaining / percentPerMillisecond).round());
    } else {
      endSlidePercent = 0.0;
      duration = Duration(
          milliseconds: (slidePercent / percentPerMillisecond).round());
    }

    completionAnimationController =
        AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(
              startSlidePercent,
              endSlidePercent,
              completionAnimationController.value,
            );

            slideUpdateStream!.add(SlideUpdate(
              UpdateType.animating,
              slideDirection,
              slidePercent,
            ));
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream!.add(SlideUpdate(
                UpdateType.doneAnimating,
                slideDirection,
                endSlidePercent,
              ));
            }
          });
  }

  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final UpdateType updateType;
  final SlideDirection? direction;
  final double slidePercent;

  SlideUpdate(
    this.updateType,
    this.direction,
    this.slidePercent,
  );
}
