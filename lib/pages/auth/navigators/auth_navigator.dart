import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../forgot_pass_page_1.dart';
import '../forgot_pass_page_2.dart';
import '../forgot_pass_page_3.dart';
import '../sing_in_page.dart';

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
        ForgotPassPage1(pageController: _pageController),
        ForgotPassPage2(pageController: _pageController),
        ForgotPassPage3(pageController: _pageController),
      ],
    );
  }
}
