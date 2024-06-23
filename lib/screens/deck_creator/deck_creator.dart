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

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/helpers/dynamic_color.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/providers/deck_list_provider.dart';
import 'package:parlera/screens/deck_creator/widgets/creator_bottom_bar.dart';
import 'package:parlera/widgets/emoji_sheet.dart';
import 'package:parlera/widgets/max_width_container.dart';

class DeckCreatorScreen extends ConsumerWidget {
  final FullDeckCompanion? startingFullDeckCompanion;

  const DeckCreatorScreen({this.startingFullDeckCompanion, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.read(deckListProvider.select((dls) => dls.valueOrNull?.locale));

    return DeckCreatorContent(
      fullDeckCompanion: startingFullDeckCompanion ??
          FullDeckCompanion.empty(
            locale ?? ParleraLocale.fromLocale(Localizations.localeOf(context)),
          ),
    );
  }
}

class DeckCreatorContent extends ConsumerStatefulWidget {
  final FullDeckCompanion fullDeckCompanion;

  const DeckCreatorContent({required this.fullDeckCompanion, super.key});

  @override
  ConsumerState<DeckCreatorContent> createState() => _DeckCreatorContentState();
}

class _DeckCreatorContentState extends ConsumerState<DeckCreatorContent> {
  static const _standardTopAreaHeight = 60.0;
  static const _creatorBottomBarHeight = 48.0;
  static final _defaultEmojiImageProvider =
      Svg(EmojiHelper.getImagePath(FullDeckCompanion.defaultEmoji));

  late ImageProvider _imageProvider;

  @override
  void initState() {
    _imageProvider = Svg(EmojiHelper.getImagePath(
        widget.fullDeckCompanion.deckCompanion.emoji.value!));

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final safeAreaTop = MediaQuery.paddingOf(context).top;
    final topAreaHeight =
        MediaQuery.sizeOf(context).height < 400 ? 8.0 : _standardTopAreaHeight;

    final colors = widget.fullDeckCompanion.generateDarkColorScheme();
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
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await ref
                    .read(deckListProvider.notifier)
                    .createOrUpdateCustomDeck(widget.fullDeckCompanion);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                      content: Text(
                          widget.fullDeckCompanion.deckCompanion.id.present
                              ? l10n.txtCategoryEdited
                              : l10n.txtCategoryAdded)),
                );
                if (context.mounted) {
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                }
              }
            },
            lang: ParleraLocale.fromLocaleCode(
                widget.fullDeckCompanion.deckCompanion.localeCode.value),
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
                          color: widget
                              .fullDeckCompanion.deckCompanion.color.value,
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
                            type: MaterialType.transparency,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async => showModalBottomSheet(
                                    context: context,
                                    builder: (_) => EmojiSheet(
                                            onEmojiSelected: (_, emoji) async {
                                          var selectedEmoji = emoji.emoji;
                                          final imagePath =
                                              EmojiHelper.getImagePath(
                                                  selectedEmoji);
                                          final scaffoldMessenger =
                                              ScaffoldMessenger.of(context);

                                          if (await EmojiHelper.imageExists(
                                              context, imagePath)) {
                                            _imageProvider = Svg(imagePath);
                                          } else {
                                            scaffoldMessenger
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  l10n.errorCouldNotFindEmoji),
                                            ));
                                            selectedEmoji =
                                                FullDeckCompanion.defaultEmoji;
                                            _imageProvider =
                                                _defaultEmojiImageProvider;
                                          }

                                          final paletteGenerator =
                                              await PaletteGenerator
                                                  .fromImageProvider(
                                                      _imageProvider);

                                          setState(() {
                                            widget.fullDeckCompanion
                                                    .deckCompanion =
                                                widget.fullDeckCompanion
                                                    .deckCompanion
                                                    .copyWith(
                                              emoji: d.Value(selectedEmoji),
                                              color: d.Value(
                                                DynamicColorHelper
                                                    .backgroundColorDark(
                                                        paletteGenerator),
                                              ),
                                            );
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
                                  label: Text(l10n.txtCategoryTitle)),
                              initialValue: widget
                                  .fullDeckCompanion.deckCompanion.name.value,
                              onSaved: (value) {
                                if (value != null) {
                                  widget.fullDeckCompanion.deckCompanion =
                                      widget.fullDeckCompanion.deckCompanion
                                          .copyWith(name: d.Value(value));
                                }
                              }))),
                  MaxWidthContainer(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              16, 6, 16, _creatorBottomBarHeight + 16),
                          child: TextFormField(
                            expands: false,
                            minLines: 10,
                            maxLines: null,
                            initialValue: widget
                                .fullDeckCompanion.contentCompanion.cards.value
                                .join("\n"),
                            decoration: InputDecoration(
                                fillColor: colors.surfaceContainerHighest,
                                label: Text(l10n.txtWordsOnePerLine),
                                alignLabelWithHint: true),
                            validator: (value) {
                              if (value == null || value.trim() == "") {
                                return l10n.warnMustEnterQuestion;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              widget.fullDeckCompanion.contentCompanion = widget
                                  .fullDeckCompanion.contentCompanion
                                  .copyWith(
                                      cards: d.Value(value
                                              ?.split("\n")
                                              .map((s) => s.trim())
                                              .where((s) => s.isNotEmpty)
                                              .toList(growable: false) ??
                                          []));
                            },
                          ))),
                ],
              ))),
        ));
  }

  Future<void> _onClose() async {
    final l10n = AppLocalizations.of(context);

    // TODO show only if edits were made
    await showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(l10n.txtDiscardChangesQ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.btnCancel)),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    },
                    child: Text(l10n.btnDiscard))
              ],
            ));
  }
}
