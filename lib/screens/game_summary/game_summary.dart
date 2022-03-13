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

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:parlera/helpers/dynamic_color.dart';
import 'package:parlera/store/category.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// TODO CAMERA: Make it work and work well
// import 'package:parlera/store/gallery.dart';
// import 'widgets/gallery_horizontal.dart';
import 'package:parlera/store/question.dart';

import 'widgets/answer_grid.dart';

class GameSummaryScreen extends StatelessWidget {
  static const _maxAnswerWidth = 320;

  const GameSummaryScreen({Key? key}) : super(key: key);

  // TODO CAMERA: Make it work and work well
  // void openGallery(BuildContext context, FileSystemEntity item) {
  //   GalleryModel.of(context).setActive(item);

  //   Navigator.pushNamed(
  //     context,
  //     '/game-gallery',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
        builder: (context, _, categoryModel) {
      return ScopedModelDescendant<QuestionModel>(
        builder: (context, _, model) {
          final imageProvider =
              AssetImage(categoryModel.currentCategory!.getImagePath());
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SingleChildScrollView(
                child: FutureBuilder(
                    future: PaletteGenerator.fromImageProvider(imageProvider),
                    builder: (context, snapshot) {
                      final bgColor = (snapshot.data == null)
                          ? Theme.of(context).backgroundColor
                          : DynamicColorHelper.backgroundColorDark(
                              snapshot.data as PaletteGenerator);
                      final lightColor = (snapshot.data == null)
                          ? Theme.of(context).colorScheme.secondary
                          : DynamicColorHelper.backgroundColorLight(
                              snapshot.data as PaletteGenerator);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ScopedModelDescendant<GalleryModel>( // TODO CAMERA: Make it work and work well
                          //   builder: (context, child, model) {
                          //     if (model.images.isEmpty) {
                          //       return Container();
                          //     }

                          //     return Padding(
                          //       padding: const EdgeInsets.only(top: 16.0),
                          //       child: GalleryHorizontal(
                          //         items: model.images,
                          //         onTap: (item) {
                          //           if (item != null) openGallery(context, item);
                          //         },
                          //       ),
                          //     );
                          //   },
                          // ),
                          Stack(children: [
                            Container(
                              height: 32 + 44,
                              color: bgColor,
                            ),
                            Positioned.directional(
                              start: 8,
                              top: 8,
                              textDirection: Directionality.of(context),
                              child: (const BackButton()),
                            ),
                            Center(
                                child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightColor,
                              ),
                              margin: const EdgeInsets.only(top: 32),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 20.0,
                              ),
                              child: Text( //todo use dynamic text size here, hardcode circle size
                                model.questionsPassed.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      color: bgColor,
                                    ),
                              ),
                            ))
                          ]),
                          AnswerGrid(
                            questionsAnswered: model.questionsAnswered,
                            answersPerRow:
                                MediaQuery.of(context).size.width.toInt() ~/
                                        _maxAnswerWidth +
                                    1,
                          ),
                        ],
                      );
                    }),
              ));
        },
      );
    });
  }
}
