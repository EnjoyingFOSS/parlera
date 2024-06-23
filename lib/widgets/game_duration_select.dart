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

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/models/game_duration_type.dart';
import 'package:parlera/models/setting_state.dart';
import 'package:parlera/providers/game_setup_provider.dart';
import 'package:parlera/providers/setting_provider.dart';
import 'package:parlera/screens/game_cover/widgets/game_duration_dialog.dart';

class GameDurationSelect extends ConsumerWidget {
  final int? defaultDeckGameDurationS;
  final ColorScheme scheme;

  const GameDurationSelect({
    super.key,
    required this.scheme,
    required this.defaultDeckGameDurationS,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final gameDurationType = ref
        .watch(settingProvider.select((v) => v.valueOrNull?.gameDurationType));
    final cardsPerGame = ref.watch(settingProvider.select(
      (v) => v.valueOrNull?.cardsPerGame,
    ));
    final customGameDuration = ref.watch(
            settingProvider.select((v) => v.valueOrNull?.customGameDuration)) ??
        SettingState.defaultCustomGameDuration;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: l10n.gameTime,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        AnimatedToggleSwitch<GameDurationType?>.rolling(
          indicatorSize: const Size(48.0, double.infinity),
          innerColor: Colors.transparent,
          indicatorColor: scheme.secondary,
          borderColor: scheme.secondary,
          loadingIconBuilder: (context, _) => CircularProgressIndicator(
            color: scheme.onSecondary,
          ),
          iconBuilder: (GameDurationType? value, _, bool active) {
            final itemColor = active ? scheme.onSecondary : scheme.onSurface;
            final textStyle = theme.textTheme.bodyMedium?.copyWith(color: itemColor);
            if (value == null) {
              return Center(
                  child: Icon(Icons.edit_rounded, size: 18, color: itemColor));
            } else if (value == GameDurationType.custom) {
              return Center(
                  child: Row(children: [
                Container(
                  width: 1,
                  height: 24,
                  color: itemColor,
                ),
                Expanded(
                    child: Text(
                  value
                      .getGameDuration(defaultDeckGameDurationS, cardsPerGame,
                          customGameDuration)
                      .toString(),
                  textAlign: TextAlign.center,
                  style: textStyle,
                )),
              ]));
            } else {
              return Center(
                  child: Text(
                value
                    .getGameDuration(defaultDeckGameDurationS, cardsPerGame,
                        customGameDuration)
                    .toString(),
                style: textStyle,
              ));
            }
          },
          current: gameDurationType,
          values: const [...GameDurationType.values, null],
          onChanged: (GameDurationType? value) async {
            final settingNotifier = ref.read(settingProvider.notifier);
            if (value != null) {
              await settingNotifier.setGameDurationType(value);
              await ref.read(gameSetupProvider.notifier).setGameDuration(
                    value.getGameDuration(defaultDeckGameDurationS,
                        cardsPerGame, customGameDuration),
                  );
            } else {
              final gameDuration = await showDialog<int?>(
                  context: context,
                  builder: (context) => const GameDurationDialog());
              if (gameDuration != null) {
                await settingNotifier.setCustomGameDuration(gameDuration);
                await settingNotifier
                    .setGameDurationType(GameDurationType.custom);
                await ref.read(gameSetupProvider.notifier).setGameDuration(
                      GameDurationType.custom.getGameDuration(
                        defaultDeckGameDurationS,
                        cardsPerGame,
                        gameDuration,
                      ),
                    );
              }
            }
          },
        )
      ],
    );
  }
}
