import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/models/language.dart';
import 'package:parlera/widgets/max_width_container.dart';

class CreatorBottomBar extends StatelessWidget {
  final void Function() onDone;
  final ParleraLanguage lang;
  final double height;

  const CreatorBottomBar(
      {required this.onDone,
      required this.lang,
      required this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final onSecondary = theme.colorScheme.onSecondary;
    return Transform.translate(
        offset: Offset(0, -1 * MediaQuery.viewInsetsOf(context).bottom),
        child: BottomAppBar(
            child: Container(
                height: height,
                color: theme.colorScheme.secondary,
                child: MaxWidthContainer(
                    alignment: Alignment.center,
                    child: Row(children: [
                      Tooltip(
                          verticalOffset: -64,
                          triggerMode: TooltipTriggerMode.tap,
                          message: AppLocalizations.of(context)
                              .txtSwitchLanguageInSettings,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.language_rounded,
                              color: onSecondary,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              lang.getLanguageName(context),
                              style: TextStyle(
                                color: onSecondary,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Icon(Icons.info_outline_rounded,
                                size: 16, color: onSecondary),
                          ])),
                      const Spacer(),
                      TextButton.icon(
                          onPressed: onDone,
                          icon: const Icon(Icons.done_rounded),
                          label: Text(AppLocalizations.of(context).btnDone)),
                      const SizedBox(
                        width: 16,
                      )
                    ])))));
  }
}
