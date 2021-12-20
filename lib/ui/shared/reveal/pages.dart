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

import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final PageViewModel? viewModel;
  final double? percentVisible;
  final VoidCallback? onSkip;

  const Page({Key? key, 
    this.viewModel,
    this.percentVisible = 1.0,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: viewModel!.color),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Opacity(
          opacity: percentVisible!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  50.0 * (1.0 - percentVisible!),
                  0.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Image.asset(
                    viewModel!.heroAssetPath,
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30.0 * (1.0 - percentVisible!),
                  0.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    viewModel!.title,
                    style: const TextStyle(
                      fontSize: 34.0,
                    ),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30.0 * (1.0 - percentVisible!),
                  0.0,
                ),
                child: Text(
                  viewModel!.body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.2,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  30.0 * (1.0 - percentVisible!),
                  0.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0, bottom: 75.0),
                  child: ElevatedButton.icon(
                    label: Text(viewModel!.skip),
                    icon: const Icon(Icons.play_circle_outline),
                    onPressed: onSkip,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String skip;

  PageViewModel(
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.skip,
  );
}
