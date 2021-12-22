import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parlera/screens/game_summary/widgets/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/models/question.dart';
import 'package:parlera/store/gallery.dart';
import 'package:parlera/store/question.dart';

import 'widgets/gallery_horizontal.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({Key? key}) : super(key: key);

  void openGallery(BuildContext context, FileSystemEntity item) {
    GalleryModel.of(context).setActive(item);

    Navigator.pushNamed(
      context,
      '/game-gallery',
    );
  }

  List<Widget> _buildAnswerGrid(List<Question> questionsAnswered) {
    final div2length = (questionsAnswered.length + 1) ~/ 2;
    return List.generate(div2length, (index) {
      //todo turn into gridview, make whole page scrollable
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            Expanded(
                child: QuestionItem(question: questionsAnswered[index * 2])),
            Container(width: 18),
            if (index * 2 + 1 < questionsAnswered.length)
              Expanded(
                  child:
                      QuestionItem(question: questionsAnswered[index * 2 + 1])),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestionModel>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 8),
                    child: Text(
                      AppLocalizations.of(context).summaryHeader,
                      // style: Theme.of(context).textTheme,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        model.questionsPassed.length.toString(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                      ),
                    ),
                  ),
                  ScopedModelDescendant<GalleryModel>(
                    builder: (context, child, model) {
                      if (model.images.isEmpty) {
                        return Container();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: GalleryHorizontal(
                          items: model.images,
                          onTap: (item) {
                            if (item != null) openGallery(context, item);
                          },
                        ),
                      );
                    },
                  ),
                  ..._buildAnswerGrid(model.questionsAnswered),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      indent: 32,
                      endIndent: 32,
                    ),
                  ),
                  ElevatedButton.icon(
                    label: Text(AppLocalizations.of(context).summaryBack),
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      // if (!SettingsModel.of(context).isNotificationsEnabled!) {
                      //   SettingsModel.of(context).enableNotifications();
                      // }
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
