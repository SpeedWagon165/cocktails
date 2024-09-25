import 'package:flutter/material.dart';

import '../filter_pages/filter_page.dart';

class FilterNavigator extends StatelessWidget {
  const FilterNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const FilterMainPage(),
        );
      },
    );
  }
}
