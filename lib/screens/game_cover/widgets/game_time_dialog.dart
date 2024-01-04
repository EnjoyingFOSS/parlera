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

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/models/category.dart';

/// Returns int?, the number of seconds chosen or null if nothing chosen
class GameTimeDialog extends StatefulWidget {
  const GameTimeDialog({super.key});

  @override
  State<GameTimeDialog> createState() => _GameTimeDialogState();
}

class _GameTimeDialogState extends State<GameTimeDialog> {
  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return AlertDialog(
        content: TextField(
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).txtCustomGameTime),
            keyboardType: TextInputType.number,
            controller: _textController,
            focusNode: _focusNode),
        actions: [
          TextButton(
              child: Text(AppLocalizations.of(context).btnCancel),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
            child: Text(AppLocalizations.of(context).btnOK),
            onPressed: () {
              final value = int.tryParse(_textController.text.toString());
              if (value == null || value <= 0) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context, min(value, Category.maxGameTime));
              }
            },
          )
        ]);
  }
}
