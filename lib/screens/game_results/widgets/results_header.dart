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

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:parlera/clippers/bottom_wave_clipper.dart';
import 'package:parlera/helpers/emoji.dart';
import 'package:parlera/helpers/hero.dart';
import 'package:parlera/models/category.dart';

class ResultsHeader extends StatefulWidget {
  final Category category;
  final double scoreRatio;
  const ResultsHeader(
      {super.key, required this.category, required this.scoreRatio});

  @override
  State<ResultsHeader> createState() => _ResultsHeaderState();
}

class _ResultsHeaderState extends State<ResultsHeader> {
  static const _standardTopAreaHeight = 60;
  static const _minimumConfettiScoreRatio =
      0.75; // TODO customize confetti and sound based on ratio
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
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final topAreaHeight =
        MediaQuery.of(context).size.height < 400 ? 8 : _standardTopAreaHeight;
    return Stack(children: [
      ClipPath(
          clipper: BottomWaveClipper(),
          child: Container(
            height: topAreaHeight + 90 + safeAreaTop,
            color: widget.category.bgColor,
          )),
      Positioned.directional(
        start: 8,
        top: 8 + safeAreaTop,
        textDirection: Directionality.of(context),
        child: (const BackButton(
          color: Colors.white,
        )),
      ),
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
              tag: HeroHelper.categoryImage(widget.category),
              child: Image(
                image: Svg(EmojiHelper.getImagePath(widget.category.emoji)),
                width: 120,
                height: 120,
              ))),
    ]);
  }

  @override
  void dispose() {
    confettiController?.dispose();
    super.dispose();
  }
}
