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

import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/models/category.dart';
import 'package:parlera/models/game_time_type.dart';
import 'package:parlera/store/settings.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GameSetings extends StatelessWidget {
  final Category category;
  const GameSetings({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
        builder: (context, child, settingsModel) {
      final selectedGameTimeType = settingsModel.gameTimeType;
      final scheme = category.getDarkColorScheme();
      final customGameTime = settingsModel.customGameTime;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).gameTime,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          AnimatedToggleSwitch<GameTimeType?>.rolling(
            indicatorSize: const Size(48.0, double.infinity),
            innerColor: Colors.transparent,
            indicatorColor: scheme.secondary,
            borderColor: scheme.secondary,
            loadingIconBuilder: (context, _) => CircularProgressIndicator(
              color: scheme.onSecondary,
            ),
            iconBuilder: (GameTimeType? value, _, bool active) {
              final itemColor = active ? scheme.onSecondary : scheme.onSurface;
              final textStyle = TextStyle(color: itemColor);
              if (value == null) {
                return Center(
                    child:
                        Icon(Icons.edit_rounded, size: 18, color: itemColor));
              } else if (value == GameTimeType.custom) {
                return Center(
                    child: Row(children: [
                  Container(
                    width: 1,
                    height: 24,
                    color: itemColor,
                  ),
                  Expanded(
                      child: Text(
                    category.getGameTime(value, customGameTime).toString(),
                    textAlign: TextAlign.center,
                    style: textStyle,
                  )),
                ]));
              } else {
                return Center(
                    child: Text(
                  category.getGameTime(value, customGameTime).toString(),
                  style: textStyle,
                ));
              }
            },
            current: selectedGameTimeType,
            values: const [...GameTimeType.values, null],
            onChanged: (GameTimeType? value) async {
              if (value != null) {
                settingsModel.setGameTimeType(value);
              } else {
                final gameTime = await _showGameTimeDialog(context);
                if (gameTime != null) {
                  settingsModel.setCustomGameTime(gameTime);
                  settingsModel.setGameTimeType(GameTimeType.custom);
                }
              }
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Bounceable(
                  scaleFactor: 0.68,
                  duration: const Duration(milliseconds: 150),
                  onTap: () {},
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(800),
                      child: Shimmer(
                          colorOpacity: 0.5,
                          child: SizedBox(
                              height: 64,
                              child: FittedBox(
                                  child: FloatingActionButton.extended(
                                backgroundColor: scheme.primary,
                                label: Text(
                                  AppLocalizations.of(context).preparationPlay,
                                  style: TextStyle(color: scheme.onPrimary),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded),
                                onPressed: () {
                                  SettingsModel.of(context)
                                      .increaseGamesPlayed();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/game-play',
                                  );
                                },
                              ))))))),
        ],
      );
    });
  }

  Future<int?> _showGameTimeDialog(BuildContext context) async {
    return await showDialog<int?>(
        builder: (context) {
          final textController = TextEditingController();
          return AlertDialog(
              content: TextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).txtCustomGameTime),
                keyboardType: TextInputType.number,
                controller: textController,
              ),
              actions: [
                TextButton(
                    child: Text(AppLocalizations.of(context).btnCancel),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(
                  child: Text(AppLocalizations.of(context).btnOK),
                  onPressed: () {
                    final value = int.tryParse(textController.text.toString());
                    if (value == null || value <= 0) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, min(value, Category.maxGameTime));
                    }
                  },
                )
              ]);
        },
        context: context);
  }
}
