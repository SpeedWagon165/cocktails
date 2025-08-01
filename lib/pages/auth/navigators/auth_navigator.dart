import 'package:cocktails/pages/auth/navigators/registration_navigator.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../forgot_pass_page_1.dart';
import '../forgot_pass_page_2.dart';
import '../forgot_pass_page_3.dart';
import '../registration_page_1.dart';
import '../sing_in_page.dart';
import 'forgot_pass_navigator.dart';

class AuthPageView extends StatefulWidget {
  const AuthPageView({super.key});

  @override
  AuthPageViewState createState() => AuthPageViewState();
}

class AuthPageViewState extends State<AuthPageView> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        SingInPage(pageController: _pageController),
        RegistrationNavigator(mainPageController: _pageController),
        ForgotPassNavigator(mainPageController: _pageController),
      ],
    );
  }
}
