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
import 'package:parlera/helpers/orientation.dart';
import 'package:parlera/models/game_setup.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/providers/game_state_provider.dart';
import 'package:parlera/screens/game_cover/widgets/deck_header.dart';
import 'package:parlera/widgets/centered_scrollable_container.dart';
import 'package:parlera/widgets/empty_content.dart';
import 'package:parlera/widgets/error_content.dart';
import 'package:parlera/widgets/game_duration_select.dart';
import 'package:parlera/widgets/play_button.dart';

class GameCoverScreen extends ConsumerWidget {
  const GameCoverScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return ref.watch(gameSetupProvider).when(
          error: (exception, stackTrace) => Scaffold(
            body: CenteredScrollableContainer(
              child: ErrorContent(exception: exception, stackTrace: stackTrace),
            ),
          ),
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive())),
          data: (gameSetup) {
            if (gameSetup == null || gameSetup.deck == null) {
              return Scaffold(
                body: CenteredScrollableContainer(
                  child: EmptyContent(
                    title: l10n.noDeckTitle,
                    subtitle: l10n.emptyCategoryQuestions,
                    iconData: Icons.apps_rounded,
                  ),
                ),
              );
            }

            final stronglyLandscape =
                OrientationHelper.isStronglyLandscape(context);
            final scheme = gameSetup.darkColorScheme;
            return Scaffold(
                backgroundColor: gameSetup.darkColorScheme.surface,
                body: stronglyLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: DeckHeader(
                            gameSetup: gameSetup,
                            isLandscape: stronglyLandscape,
                          )),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GameDurationSelect(
                                scheme: scheme,
                                defaultDeckGameDurationS:
                                    gameSetup.deck?.mediumGameDurationS,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                child: PrimaryButton(
                                  scheme: scheme,
                                  label: l10n.preparationPlay,
                                  onTap: () async => await _onPlayGame(
                                      context, ref, gameSetup),
                                ),
                              ),
                            ],
                          )),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            DeckHeader(
                              gameSetup: gameSetup,
                              isLandscape: stronglyLandscape,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            GameDurationSelect(
                              scheme: scheme,
                              defaultDeckGameDurationS:
                                  gameSetup.deck?.mediumGameDurationS,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: PrimaryButton(
                                scheme: scheme,
                                label: l10n.preparationPlay,
                                onTap: () async =>
                                    await _onPlayGame(context, ref, gameSetup),
                              ),
                            ),
                          ],
                        ),
                      ));
          },
        );
  }

  Future<void> _onPlayGame(
      BuildContext context, WidgetRef ref, GameSetup gameSetup) async {
    ref.read(gameStateProvider.notifier).setGameSetupState(gameSetup);
    await Navigator.pushReplacementNamed(
      context,
      '/game-play',
    );
  }
}
