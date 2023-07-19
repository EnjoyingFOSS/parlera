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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parlera/screens/settings/widgets/settings_list.dart';
import 'package:parlera/screens/settings/widgets/settings_modal.dart';
import 'package:parlera/widgets/max_width_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static Future<void> showBottomSheet(BuildContext context) async =>
      await showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => const SettingsModal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaxWidthContainer(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(AppLocalizations.of(context).settings)),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8),
              sliver: SettingsList())
        ],
      )),
    );
  }
}
