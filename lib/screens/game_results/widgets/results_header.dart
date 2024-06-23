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

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/helpers/audio.dart';
import 'package:parlera/helpers/layout.dart';
import 'package:parlera/models/game_setup.dart';
import 'package:parlera/providers/audio_provider.dart';

class ResultsHeader extends ConsumerStatefulWidget {
  final GameSetup gameSetup;
  final double scoreRatio;
  const ResultsHeader(
      {required this.gameSetup, required this.scoreRatio, super.key});

  @override
  ConsumerState<ResultsHeader> createState() => _ResultsHeaderState();
}

class _ResultsHeaderState extends ConsumerState<ResultsHeader> {
  static const _standardTopAreaHeight = 60;
  static const _minimumConfettiScoreRatio =
      0.75; // TODO customize confetti and sound based on ratio; e.g. star confetti at 100%
  late final ConfettiController? confettiController;

  @override
  void initState() {
    super.initState();
    if (widget.scoreRatio >= _minimumConfettiScoreRatio) {
      confettiController =
          ConfettiController(duration: const Duration(seconds: 3));
      confettiController?.play();
    } else {
      confettiController = null;
    }
    Future.delayed(const Duration(milliseconds: 150),
        () async => await AudioHelper.playResults(ref.read(audioProvider)));
  }

  @override
  void dispose() {
    confettiController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.paddingOf(context).top;
    final topAreaHeight =
        MediaQuery.sizeOf(context).height < 400 ? 8 : _standardTopAreaHeight;

    return Stack(children: [
      ClipPath(
          clipper: BottomWaveClipper(),
          child: Container(
            height: topAreaHeight + 90 + safeAreaTop,
            color: widget.gameSetup.deck?.color ??
                widget.gameSetup.gameSetupType.defaultColor,
          )),
      Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 8 + safeAreaTop, 8, 0),
            alignment: AlignmentDirectional.topStart,
            width: LayoutXL.cols12.width,
            child: const BackButton(
              color: Colors.white,
            ),
          )),
      if (confettiController != null)
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            numberOfParticles: (10 * widget.scoreRatio).floor(),
            maxBlastForce: 20 * widget.scoreRatio,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            confettiController: confettiController!,
          ),
        ),
      Container(
          margin: EdgeInsets.only(top: topAreaHeight + safeAreaTop),
          alignment: Alignment.center,
          child: Hero(
            tag: widget.gameSetup.heroTag,
            child: Image(
              image: Svg(widget.gameSetup.emojiPath),
              width: 120,
              height: 120,
            ),
          )),
    ]);
  }
}
