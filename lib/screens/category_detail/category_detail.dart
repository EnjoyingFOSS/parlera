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

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/settings.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({Key? key}) : super(key: key);

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
    return ScopedModelDescendant<CategoryModel>(
      builder: (context, _, model) {
        final category = model.currentCategory!;
        final description = category.description ?? "";
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () => model.toggleFavorite(category),
                  icon: Icon(
                    model.isFavorite(category)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Hero(
                        tag: 'categoryImage-${category.name}',
                        child: Image.asset(
                          category.getImagePath(),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    category.name ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  if (description != "")
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
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          AnimatedToggleSwitch<int>.rolling(
                            innerColor: Colors.transparent,
                            iconBuilder: (int value, _, bool active) {
                              return Center(
                                  child: Text(
                                AppLocalizations.of(context).secondsTemplate.replaceFirst('%d', value.toString()),
                                style: TextStyle(
                                    color: active
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSecondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ));
                            },
                            indicatorType: IndicatorType.circle,
                            current: settingsModel.roundTime,
                            values: const [30, 60, 90, 120],
                            onChanged: (int value) {
                              //     "settings_round_time", {"value": value});
                              settingsModel.changeRoundTime(value);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(AppLocalizations.of(context).preparationPlay),
                      icon: const Icon(Icons.play_arrow_rounded),
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
            ));
      },
    );
  }
}
