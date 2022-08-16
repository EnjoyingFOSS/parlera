import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../helpers/language.dart';

class CreatorBottomBar extends StatelessWidget {
  final void Function() onDone;
  final ColorScheme colors;
  final String langCode;

  const CreatorBottomBar(
      {Key? key,
      required this.onDone,
      required this.colors,
      required this.langCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
            child: Container(
                height: 48,
                color: colors.secondary,
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
                          Icons.language,
                          color: colors.onSecondary,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          LanguageHelper.getLanguageName(context, langCode),
                          style: TextStyle(
                            color: colors.onSecondary,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(Icons.info_outline,
                            size: 16, color: colors.onSecondary),
                      ])),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: onDone,
                      icon: const Icon(Icons.done),
                      label: Text(AppLocalizations.of(context).btnDone)),
                  const SizedBox(
                    width: 16,
                  )
                ]))));
  }
}
