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

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:parlera/helpers/dynamic_color.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/theme.dart';
import 'package:parlera/screens/category_creator/widgets/creator_bottom_bar.dart';
import 'package:parlera/screens/category_creator/widgets/emoji_painter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/editable_category.dart';
import '../../store/category.dart';
import '../../store/language.dart';
import 'widgets/emoji_paint_widget.dart';

class CategoryCreatorScreen extends StatefulWidget {
  final EditableCategory? ec;

  const CategoryCreatorScreen({Key? key, this.ec}) : super(key: key);

  @override
  State<CategoryCreatorScreen> createState() => _CategoryCreatorScreenState();
}

class _CategoryCreatorScreenState extends State<CategoryCreatorScreen> {
  static const _standardTopAreaHeight = 60;

  late final EditableCategory _editableCategory;

  @override
  void initState() {
    _editableCategory = widget.ec ?? EditableCategory();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final topAreaHeight =
        MediaQuery.of(context).size.height < 400 ? 8 : _standardTopAreaHeight;

    return ScopedModelDescendant<LanguageModel>(builder: (context, _, model) {
      final modelLanguage = model.lang;
      final colors = Theme.of(context).colorScheme;
      if (modelLanguage != null) _editableCategory.lang = modelLanguage;
      return WillPopScope(
          onWillPop: () async {
            _onClose();
            return false;
          },
          child: Scaffold(
            bottomNavigationBar: CreatorBottomBar(
              onDone: () async {
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {
                  form?.save();
                  CategoryModel.of(context)
                      .createOrUpdateCustomCategory(_editableCategory);
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_editableCategory.sembastPos == null
                          ? AppLocalizations.of(context).txtCategoryAdded
                          : AppLocalizations.of(context).txtCategoryEdited)));
                }
              },
              colors: colors,
              lang: _editableCategory.lang,
            ),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Container(
                        height: topAreaHeight + 90 + safeAreaTop,
                        color: _editableCategory.bgColor,
                      ),
                      Positioned.directional(
                        start: 8,
                        top: 8 + safeAreaTop,
                        textDirection: Directionality.of(context),
                        child: (const CloseButton()),
                      ),
                      Container(
                          margin:
                              EdgeInsets.only(top: topAreaHeight + safeAreaTop),
                          alignment: Alignment.center,
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: _showEmojiSheet,
                                  child: SizedBox(
                                      width: 136,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: Text(
                                            _editableCategory.emoji,
                                            style: ThemeHelper.emojiStyle
                                                .copyWith(
                                                    fontSize: 100 /
                                                        MediaQuery.of(context)
                                                            .textScaleFactor),
                                          )
                                              //     Image(
                                              //   image: _imageProvider,
                                              //   width: 120,
                                              //   height: 120,
                                              // )
                                              ),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: colors.secondary,
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 18,
                                                    color: colors.onSecondary,
                                                  )))
                                        ],
                                      )))))
                    ]),
                    const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                              label: Text(AppLocalizations.of(context)
                                  .txtCategoryTitle)),
                          initialValue: _editableCategory.name,
                          onSaved: (value) => _editableCategory.name = value,
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: TextFormField(
                          expands: false,
                          minLines: null,
                          maxLines: 10,
                          initialValue: _editableCategory.questions?.join("\n"),
                          decoration: InputDecoration(
                              label: Text(AppLocalizations.of(context)
                                  .txtWordsOnePerLine),
                              alignLabelWithHint: true),
                          validator: (value) {
                            if (value == null || value.trim() == "") {
                              return AppLocalizations.of(context)
                                  .warnMustEnterQuestion;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editableCategory.questions = value?.split("\n");
                          },
                        )),
                  ],
                ))),
          ));
    });
  }

  void _onClose() {
    // todo show only if edits were made
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(AppLocalizations.of(context).txtDiscardChangesQ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).btnCancel)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).btnDiscard))
              ],
            ));
  }

  Future<void> _showEmojiSheet() => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          //todo add search
          EmojiPicker(
            config: const Config(
                checkPlatformCompatibility: false,
                emojiTextStyle: ThemeHelper.emojiStyle),
            onEmojiSelected: (_, emoji) async {
              final selectedEmoji = emoji.emoji;

              final paletteGenerator = await PaletteGenerator.fromImage(
                  await EmojiPainter.getImage(
                      emoji.emoji, MediaQuery.of(context).textScaleFactor));

              setState(() {
                _editableCategory.emoji = selectedEmoji;

                _editableCategory.bgColor =
                    DynamicColorHelper.backgroundColorDark(paletteGenerator);
              });
              if (!mounted) return;
              Navigator.of(context)
                  .pop(); //todo add a warning about emojis not looking the same on iOS
            },
          ));
}
