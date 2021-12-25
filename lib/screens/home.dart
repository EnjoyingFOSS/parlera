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
//
// This file is derived from work covered by the following license notice:
//
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'package:flutter/material.dart';
import 'package:parlera/screens/category_list/category_list.dart';
import 'package:parlera/screens/settings.dart';
import 'package:parlera/widgets/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/store/question.dart';
import 'package:parlera/store/tutorial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Tab> _tabs = <Tab>[
    const Tab(icon: Icon(Icons.play_circle_filled)),
    const Tab(icon: Icon(Icons.favorite)),
    const Tab(icon: Icon(Icons.settings)),
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

    if (!isTutorialWatched()) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.pushNamed(
            context,
            '/tutorial',
          ));
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  bool isTutorialWatched() {
    return TutorialModel.of(context).isWatched;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
      builder: (context, child, model) => ScopedModelDescendant<QuestionModel>(
        builder: (context, child, qModel) {
          if (model.isLoading || qModel.isLoading) {
            return const ScreenLoader();
          }

          return Scaffold(
            bottomNavigationBar: Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 55,
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: _tabs,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: const [
                CategoryListScreen(
                  type: CategoryType.all,
                ),
                CategoryListScreen(
                  type: CategoryType.favorites,
                ),
                SettingsScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
