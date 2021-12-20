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
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/localizations.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/settings.dart';
import 'package:parlera/ui/templates/screen.dart';
import 'package:parlera/ui/theme.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({Key? key}) : super(key: key);

  Widget buildFavorite({required bool isFavorite, Function? onPressed}) {
    return IconButton(
      onPressed: onPressed as void Function()?,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? secondaryDarkColor : Colors.white,
      ),
    );
  }

  Widget buildRoundTimeSelectItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      showBack: true,
      child: ScopedModelDescendant<CategoryModel>(
        builder: (context, child, model) {
          var category = model.currentCategory!;

          return SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: ThemeConfig.categoryImageSize,
                          height: ThemeConfig.categoryImageSize,
                          child: Hero(
                            tag: 'categoryImage-${category.name}',
                            child: SvgPicture.asset(
                              category.getImagePath(),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            category.description!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(height: 1.2),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          indent: 32,
                          endIndent: 32,
                        ),
                      ),
                      ScopedModelDescendant<SettingsModel>(
                        builder: (context, child, settingsModel) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context).gameTime,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              CupertinoSegmentedControl(
                                padding: const EdgeInsets.only(top: 8),
                                borderColor: Colors.white,
                                selectedColor: secondaryColor,
                                pressedColor: secondaryDarkColor,
                                unselectedColor: Theme.of(context).primaryColor,
                                children: {
                                  30: buildRoundTimeSelectItem("30s"),
                                  60: buildRoundTimeSelectItem("60s"),
                                  90: buildRoundTimeSelectItem("90s"),
                                  120: buildRoundTimeSelectItem("120s"),
                                },
                                groupValue: settingsModel.roundTime!.toDouble(),
                                onValueChanged: (dynamic value) {
                                  //     "settings_round_time", {"value": value});
                                  settingsModel.changeRoundTime(value.toInt());
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: ElevatedButton.icon(
                          label: Text(
                              AppLocalizations.of(context).preparationPlay),
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: () {
                            SettingsModel.of(context).increaseGamesPlayed();

                            Navigator.pushReplacementNamed(
                              context,
                              '/game-play',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: buildFavorite(
                    isFavorite: model.isFavorite(category),
                    onPressed: () => model.toggleFavorite(category),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
