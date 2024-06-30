import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class StyleBottomNavBar extends StatelessWidget {
  const StyleBottomNavBar({
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    super.key,
  });

  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  Widget _buildItem(ItemConfig item, bool isSelected) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeForegroundColor
                    : item.inactiveForegroundColor,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          Container(
            height: 3,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:
                  isSelected ? item.activeBackgroundColor : Colors.transparent,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => DecoratedNavBar(
        decoration: navBarDecoration,
        filter: navBarConfig.selectedItem.filter,
        opacity: navBarConfig.selectedItem.opacity,
        height: navBarConfig.navBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navBarConfig.items.map((item) {
            final int index = navBarConfig.items.indexOf(item);
            return Expanded(
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  navBarConfig.onItemSelected(index);
                },
                child: _buildItem(
                  item,
                  navBarConfig.selectedIndex == index,
                ),
              ),
            );
          }).toList(),
        ),
      );
}
