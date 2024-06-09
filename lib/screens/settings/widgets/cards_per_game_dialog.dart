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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/repository/settings.dart';

enum _CPGOption {
  normal(SettingsRepository.defaultCardsPerGame),
  shorter(SettingsRepository.defaultCardsPerGame ~/ 2),
  unlimited(null),
  custom(-1);

  final int? intValue;

  const _CPGOption(this.intValue);

  static _CPGOption fromInteger(int? cardsPerGame) {
    if (cardsPerGame == _CPGOption.normal.intValue) {
      return _CPGOption.normal;
    } else if (cardsPerGame == _CPGOption.shorter.intValue) {
      return _CPGOption.shorter;
    } else if (cardsPerGame == _CPGOption.unlimited.intValue) {
      return _CPGOption.unlimited;
    } else {
      return _CPGOption.custom;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case _CPGOption.normal:
      case _CPGOption.shorter:
        return intValue.toString();
      case _CPGOption.unlimited:
        return AppLocalizations.of(context).txtUnlimitedCards;
      case _CPGOption.custom:
        return AppLocalizations.of(context).txtCustomCardNumber;
    }
  }
}

class CardsPerGameDialog extends StatefulWidget {
  final int? currentCardsPerGame;

  const CardsPerGameDialog({required this.currentCardsPerGame, super.key});

  @override
  State<CardsPerGameDialog> createState() => _CardsPerGameDialogState();

  static Future<int?> show(
      BuildContext context, int? currentCardsPerGame) async {
    return await showDialog<int?>(
        barrierDismissible: false,
        context: context,
        builder: (_) =>
            CardsPerGameDialog(currentCardsPerGame: currentCardsPerGame));
  }
}

class _CardsPerGameDialogState extends State<CardsPerGameDialog> {
  static const _maxCardsPerGame = 100;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late _CPGOption chosenValue;

  @override
  void initState() {
    super.initState();
    chosenValue = _CPGOption.fromInteger(widget.currentCardsPerGame);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO submit on Enter
    if (chosenValue == _CPGOption.custom) {
      _focusNode.requestFocus();
    }
    return AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ..._CPGOption.values.map((o) => RadioListTile(
              title: Text(o.getLabel(context)),
              value: o,
              groupValue: chosenValue,
              onChanged: (newValue) => setState(() {
                    if (newValue != null) {
                      chosenValue = newValue;
                    }
                  }))),
          if (chosenValue == _CPGOption.custom)
            TextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).txtCardsPerGame),
                keyboardType: TextInputType.number,
                controller: _textController,
                focusNode: _focusNode)
        ]),
        actions: [
          TextButton(
              child: Text(AppLocalizations.of(context).btnCancel),
              onPressed: () {
                Navigator.pop(context, widget.currentCardsPerGame);
              }),
          TextButton(
            child: Text(AppLocalizations.of(context).btnOK),
            onPressed: () {
              if (chosenValue == _CPGOption.custom) {
                final customValue =
                    int.tryParse(_textController.text.toString());
                if (customValue == null || customValue <= 0) {
                  Navigator.pop(context, widget.currentCardsPerGame);
                } else {
                  Navigator.pop(context, min(customValue, _maxCardsPerGame));
                }
              } else {
                Navigator.pop(context, chosenValue.intValue);
              }
            },
          )
        ]);
  }
}
