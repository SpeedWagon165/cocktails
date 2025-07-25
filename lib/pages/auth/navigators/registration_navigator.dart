import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../registration_page_1.dart';
import '../registration_page_2.dart';
import '../registration_page_3.dart';
import '../registration_page_4.dart';
import '../permission_page.dart';

class RegistrationNavigator extends StatefulWidget {
  final PageController mainPageController;

  const RegistrationNavigator({super.key, required this.mainPageController});

  @override
  RegistrationNavigatorState createState() => RegistrationNavigatorState();
}

class RegistrationNavigatorState extends State<RegistrationNavigator> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        RegistrationPage1(
            pageController: _pageController,
            mainPageController: widget.mainPageController),
        RegistrationPage2(
          pageController: _pageController,
        ),
        RegistrationPage3(
          pageController: _pageController,
        ),
        RegistrationPage4(
          pageController: _pageController,
        ),
        RegistrationPage5(
          pageController: _pageController,
        ),
      ],
    );
  }
}
