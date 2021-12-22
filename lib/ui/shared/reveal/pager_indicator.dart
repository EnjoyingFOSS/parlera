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
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
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

import 'dart:ui';

import 'package:flutter/material.dart';

import 'pages.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel? viewModel;

  const PagerIndicator({Key? key, 
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel!.pages.length; ++i) {
      final page = viewModel!.pages[i];

      double? percentActive;
      if (i == viewModel!.activeIndex) {
        percentActive = 1.0 - viewModel!.slidePercent!;
      } else if (i == viewModel!.activeIndex - 1 &&
          viewModel!.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel!.slidePercent;
      } else if (i == viewModel!.activeIndex + 1 &&
          viewModel!.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel!.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i != viewModel!.activeIndex;

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            page.color,
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(child: Container()),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection? slideDirection;
  final double? slidePercent;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel? viewModel;

  const PageBubble({Key? key, 
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryVariant;

    return SizedBox(
      width: 25.0,
      height: 55.0,
      child: Center(
        child: Container(
          width: lerpDouble(12.0, 16.0, viewModel!.activePercent!),
          height: lerpDouble(12.0, 16.0, viewModel!.activePercent!),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2.0),
            color: viewModel!.isHollow
                ? color.withOpacity(viewModel!.activePercent!)
                : Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: viewModel!.isHollow
                  ? color.withOpacity(1 - viewModel!.activePercent!)
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final Color color;
  final bool isHollow;
  final double? activePercent;

  PageBubbleViewModel(
    this.color,
    this.isHollow,
    this.activePercent,
  );
}
