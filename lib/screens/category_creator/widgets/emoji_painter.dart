import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:parlera/helpers/theme.dart';

class EmojiPainter extends CustomPainter {
  final String emoji;
  final double fontSize;
  final double textScaleFactor;

  EmojiPainter(this.emoji, this.fontSize, this.textScaleFactor);

  static Future<Image> getImage(String emoji, double textScaleFactor) {
    const size = 128;
    final doubleSize = size.toDouble();
    final pr = PictureRecorder();
    final canvas = Canvas(pr);
    EmojiPainter(emoji, doubleSize, textScaleFactor)
        .paint(canvas, Size(doubleSize, doubleSize));

    return pr.endRecording().toImage(size, size);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
        text: emoji,
        style: ThemeHelper.emojiStyle
            .copyWith(fontSize: fontSize / (textScaleFactor * 1.25)));
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(canvas, const Offset(0, 0));
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
