import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_mvvm/presentation/main/pages/home/view/home_page.dart';
import 'package:ecommerce_mvvm/presentation/main/pages/notifications/notifications_page.dart';
import 'package:ecommerce_mvvm/presentation/main/pages/search/search_page.dart';
import 'package:ecommerce_mvvm/presentation/main/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage()
  ];
  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr()
  ];
  var _title = AppStrings.home.tr();
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
            selectedItemColor: ColorManager.primary,
            unselectedItemColor: ColorManager.grey,
            currentIndex: _currentIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(ImageAssets.homeIc)),
                  label: AppStrings.home.tr()),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(ImageAssets.searchIc)),
                  label: AppStrings.search.tr()),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(ImageAssets.notificationsIc)),
                  label: AppStrings.notifications),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(ImageAssets.settingsIc)),
                  label: AppStrings.settings.tr()),
            ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
