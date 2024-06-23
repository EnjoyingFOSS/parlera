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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/helpers/audio.dart';
import 'package:parlera/models/setting_state.dart';
import 'package:parlera/providers/audio_provider.dart';
import 'package:parlera/providers/combo_provider.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/providers/game_state_provider.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/screens/home/widgets/combo_card.dart';
import 'package:parlera/widgets/centered_scrollable_container.dart';
import 'package:parlera/widgets/empty_content.dart';
import 'package:parlera/widgets/error_content.dart';
import 'package:parlera/widgets/game_duration_select.dart';
import 'package:parlera/widgets/max_width_container.dart';
import 'package:parlera/widgets/play_button.dart';

class ComboSubscreen extends ConsumerWidget {
  final double bottomMargin;

  const ComboSubscreen({
    required this.bottomMargin,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    return ref.watch(comboProvider).when(
          error: (exception, stackTrace) => CenteredScrollableContainer(
              padding: EdgeInsets.only(bottom: bottomMargin),
              child:
                  ErrorContent(exception: exception, stackTrace: stackTrace)),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          data: (combo) {
            if (combo?.isEmpty ?? true) {
              return CenteredScrollableContainer(
                padding: EdgeInsets.only(bottom: bottomMargin),
                child: EmptyContent(
                  title: l10n.noComboTitle,
                  subtitle: l10n.noComboSubtitle,
                  iconData: Icons.category_rounded,
                ),
              );
            } else {
              return MaxWidthContainer(
                child: SafeArea(
                    child: CustomScrollView(
                  primary: false,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                      sliver: SliverAppBar(
                        title: Text(AppLocalizations.of(context).combo,
                            style: const TextStyle(fontSize: 52)),
                        actions: [
                          IconButton(
                            tooltip: l10n.generateRandomCombo,
                            onPressed: () async {
                              await AudioHelper.playDiceRoll(
                                  ref.read(audioProvider));
                              ref.read(comboProvider.notifier).regenerate();
                            },
                            icon: const Icon(Icons.casino_rounded),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
                      sliver: SliverList.list(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: combo!
                              .map((cs) => Expanded(
                                    child: ComboCard(deck: cs),
                                  ))
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 24),
                        GameDurationSelect(
                          scheme: scheme,
                          defaultDeckGameDurationS: null,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: PrimaryButton(
                              scheme: scheme,
                              label: l10n.preparationPlay,
                              onTap: () async {
                                final settingState = ref
                                        .read(settingProvider)
                                        .valueOrNull ??
                                    const SettingState(rotationEnabled: false);
                                await ref
                                    .read(gameSetupProvider.notifier)
                                    .setCombo(
                                        combo,
                                        settingState
                                            .gameDurationType
                                            .getGameDuration(
                                                null,
                                                settingState.cardsPerGame,
                                                settingState
                                                    .customGameDuration),
                                        settingState.cardsPerGame);
                                ref
                                    .read(gameStateProvider.notifier)
                                    .setGameSetupState(
                                        ref.read(gameSetupProvider).value!);
                                if (context.mounted) {
                                  await Navigator.pushNamed(
                                    context,
                                    '/game-play',
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                )),
              );
            }
          },
        );
  }
}
