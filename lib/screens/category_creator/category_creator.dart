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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/helpers/dynamic_color.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/models/editable_category.dart';
import 'package:parlera/screens/category_creator/widgets/creator_bottom_bar.dart';
import 'package:parlera/store/category.dart';
import 'package:parlera/store/language.dart';
import 'package:parlera/widgets/emoji_sheet.dart';
import 'package:parlera/widgets/max_width_container.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoryCreatorScreen extends StatefulWidget {
  final EditableCategory? ec;

  const CategoryCreatorScreen({this.ec, super.key});

  @override
  State<CategoryCreatorScreen> createState() => _CategoryCreatorScreenState();
}

class _CategoryCreatorScreenState extends State<CategoryCreatorScreen> {
  static const _standardTopAreaHeight = 60.0;
  static const _creatorBottomBarHeight = 48.0;
  static const _missingEmoji = "❔";
  static final _missingImageProvider =
      Svg(EmojiHelper.getImagePath(_missingEmoji));

  late final EditableCategory _editableCategory;
  late ImageProvider _imageProvider;

  @override
  void initState() {
    _editableCategory = widget.ec ?? EditableCategory();
    _imageProvider = Svg(EmojiHelper.getImagePath(_editableCategory.emoji));
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.paddingOf(context).top;
    final topAreaHeight =
        MediaQuery.sizeOf(context).height < 400 ? 8.0 : _standardTopAreaHeight;

    return ScopedModelDescendant<LanguageModel>(builder: (context, _, model) {
      final modelLanguage = model.lang;
      final colors = _editableCategory.generateDarkColorScheme();
      if (modelLanguage != null) _editableCategory.lang = modelLanguage;
      return WillPopScope(
          onWillPop: () async {
            await _onClose();
            return false;
          },
          child: Scaffold(
            backgroundColor: colors.surfaceContainerLow,
            bottomNavigationBar: CreatorBottomBar(
              onDone: () async {
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {
                  form?.save();
                  final localizations = AppLocalizations.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await CategoryModel.of(context)
                      .createOrUpdateCustomCategory(_editableCategory);
                  scaffoldMessenger.showSnackBar(SnackBar(
                      content: Text(_editableCategory.sembastPos == null
                          ? localizations.txtCategoryAdded
                          : localizations.txtCategoryEdited)));
                  if (context.mounted) {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  }
                }
              },
              lang: _editableCategory.lang,
              height: _creatorBottomBarHeight,
            ),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            height: topAreaHeight + 90 + safeAreaTop,
                            color: _editableCategory.bgColor,
                          )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(8, 8 + safeAreaTop, 8, 0),
                            alignment: AlignmentDirectional.topStart,
                            width: LayoutXL.cols12.width,
                            child: const CloseButton(
                              color: Colors.white,
                            ),
                          )),
                      Container(
                          margin:
                              EdgeInsets.only(top: topAreaHeight + safeAreaTop),
                          alignment: Alignment.center,
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () async => showModalBottomSheet(
                                      context: context,
                                      builder: (_) => EmojiSheet(
                                              onEmojiSelected:
                                                  (_, emoji) async {
                                            var selectedEmoji = emoji.emoji;
                                            final imagePath =
                                                EmojiHelper.getImagePath(
                                                    selectedEmoji);
                                            final scaffoldMessenger =
                                                ScaffoldMessenger.of(context);
                                            final l10n =
                                                AppLocalizations.of(context);

                                            if (await EmojiHelper.imageExists(
                                                context, imagePath)) {
                                              _imageProvider = Svg(imagePath);
                                            } else {
                                              scaffoldMessenger
                                                  .showSnackBar(SnackBar(
                                                content: Text(l10n
                                                    .errorCouldNotFindEmoji),
                                              ));
                                              selectedEmoji = _missingEmoji;
                                              _imageProvider =
                                                  _missingImageProvider;
                                            }

                                            final paletteGenerator =
                                                await PaletteGenerator
                                                    .fromImageProvider(
                                                        _imageProvider);

                                            setState(() {
                                              _editableCategory
                                                ..emoji = selectedEmoji
                                                ..bgColor = DynamicColorHelper
                                                    .backgroundColorDark(
                                                        paletteGenerator);
                                            });
                                            if (context.mounted) {
                                              Navigator.of(context)
                                                  .pop(); //TODO add a warning about emojis not looking the same on iOS
                                            }
                                          })),
                                  child: SizedBox(
                                      width: 136,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: Image(
                                            image: _imageProvider,
                                            width: 120,
                                            height: 120,
                                          )),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: colors.secondary,
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.edit_rounded,
                                                    size: 18,
                                                    color: colors.onSecondary,
                                                  )))
                                        ],
                                      )))))
                    ]),
                    const SizedBox(height: 16),
                    MaxWidthContainer(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: colors.surfaceContainerHighest,
                                  label: Text(AppLocalizations.of(context)
                                      .txtCategoryTitle)),
                              initialValue: _editableCategory.name,
                              onSaved: (value) =>
                                  _editableCategory.name = value,
                            ))),
                    MaxWidthContainer(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 6, 16, _creatorBottomBarHeight + 16),
                            child: TextFormField(
                              expands: false,
                              minLines: 10,
                              maxLines: null,
                              initialValue: _editableCategory.cards?.join("\n"),
                              decoration: InputDecoration(
                                  fillColor: colors.surfaceContainerHighest,
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
                                _editableCategory.cards = value
                                    ?.split("\n")
                                    .map((s) => s.trim())
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                              },
                            ))),
                  ],
                ))),
          ));
    });
  }

  Future<void> _onClose() async {
    // todo show only if edits were made
    await showDialog<AlertDialog>(
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
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Text(AppLocalizations.of(context).btnDiscard))
              ],
            ));
  }
}
