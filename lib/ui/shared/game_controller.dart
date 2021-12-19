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

class GameController extends StatefulWidget {
  GameController({
    Key? key,
    this.child,
    this.alignment,
    this.color,
    this.onTap,
  }) : super(key: key);

  final Widget? child;
  final Alignment? alignment;
  final Color? color;
  final Function? onTap;

  @override
  _GameControllerState createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Container(
          alignment: widget.alignment,
          child: Opacity(opacity: 0.6, child: widget.child),
          height: double.infinity,
          decoration: BoxDecoration(color: widget.color),
        ),
      ),
    );
  }
}
