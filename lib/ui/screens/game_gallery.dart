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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parlera/store/gallery.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:parlera/ui/templates/screen.dart';

import '../theme.dart';

class GameGalleryScreen extends StatelessWidget {
  const GameGalleryScreen({Key? key}) : super(key: key);

  Widget buildGallery() {
    return ScopedModelDescendant<GalleryModel>(
        builder: (context, child, model) {
      var images = model.images;

      return CarouselSlider(
        options: CarouselOptions(
          enableInfiniteScroll: true,
          height: MediaQuery.of(context).size.height * 0.8,
          enlargeCenterPage: false,
          autoPlay: false,
          viewportFraction: 1.0,
          initialPage: images.indexOf(model.activeImage),
          onPageChanged: (index, _) {
            model.setActive(images[index]);
          },
        ),
        items: images.map((item) {
          return Stack(children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SpinKitRing(color: secondaryColor, size: 70.0),
            ),
            Builder(
              builder: (BuildContext context) {
                return Center(
                  child: Stack(
                    children: [
                      Image.file(item as File, fit: BoxFit.contain),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: FloatingActionButton(
                          elevation: 0.0,
                          child: const Icon(Icons.share),
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            
                            Share.shareFiles([item.path]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]);
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      showBack: true,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: buildGallery(),
            ),
          ],
        ),
      ),
    );
  }
}
