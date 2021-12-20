import 'package:flutter/material.dart';
import 'package:parlera/ui/shared/screen_loader.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:parlera/store/category.dart';
import 'package:parlera/store/question.dart';
import 'package:parlera/store/tutorial.dart';
import 'package:parlera/ui/screens/category_list.dart';
import 'package:parlera/ui/screens/category_favorites.dart';
import 'package:parlera/ui/screens/settings.dart';
import 'package:parlera/ui/templates/screen.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    const Tab(icon: Icon(Icons.play_circle_filled)),
    const Tab(icon: Icon(Icons.favorite)),
    const Tab(icon: Icon(Icons.settings)),
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

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
          if (model.isLoading || qModel.isLoading || !isTutorialWatched()) {
            return const ScreenLoader();
          }

          return ScreenTemplate(
            child: Scaffold(
              bottomNavigationBar: Container(
                color: primaryDarkColor,
                height: 55,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).colorScheme.secondary,
                    unselectedLabelColor: primaryLightColor,
                    indicatorColor: primaryDarkColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: const [
                  CategoryListScreen(),
                  CategoryFavoritesScreen(),
                  SettingsScreen(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
