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
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/localizations.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/ui/theme.dart';
import 'package:parlera/models/category.dart';

class CategoryListItem extends StatefulWidget {
  const CategoryListItem({
    Key? key,
    this.category,
    this.onTap,
  }) : super(key: key);

  final Category? category;
  final VoidCallback? onTap;

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  Widget buildMetaItem(String text, [IconData? icon]) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        children: [
          if (icon != null)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(icon, size: 14)),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: ThemeConfig.categoriesMetaSize,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int questionCount = widget.category!.questions.length;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(children: [
        Hero(
          tag: 'categoryImage-${widget.category!.name}',
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: SvgPicture.asset(widget.category!.getImagePath(),
                  fit: BoxFit.contain)),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            widget.category!.name!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 30,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              height: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
        ),
        ScopedModelDescendant<CategoryModel>(
          builder: (context, child, model) {
            return Positioned(
              bottom: 10,
              left: 10,
              child: buildMetaItem(
                model.getPlayedCount(widget.category!).toString(),
                Icons.play_arrow,
              ),
            );
          },
        ),
        if (questionCount > 0)
          Positioned(
            bottom: 10,
            right: 10,
            child: buildMetaItem(
              AppLocalizations.of(context)
                  .categoryItemQuestionsCount(questionCount),
            ),
          )
      ]),
    );
  }
}
