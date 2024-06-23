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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/helpers/url_util.dart';

class ErrorContent extends StatelessWidget {
  //TODO allow putting in a stack trace
  static const _replacementPlaceholder = "@@";

  final Object exception;
  final StackTrace stackTrace;

  const ErrorContent(
      {super.key, required this.exception, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final stringSplit = l10n
        .errorDescription(_replacementPlaceholder)
        .split(_replacementPlaceholder);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bug_report_rounded,
            size: 128,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.errorTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: stringSplit.first),
                  TextSpan(
                      text: l10n.errorDescriptionBugLinkSegment,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async => await URLUtil.launchURL(context,
                            "https://gitlab.com/enjoyingfoss/parlera/-/issues")),
                  TextSpan(text: stringSplit.last)
                ],
                style: theme.textTheme.bodyMedium,
              ),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
