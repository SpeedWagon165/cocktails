import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/auth/auth_pop_up.dart';
import '../../widgets/custom_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: 'Пропустить',
                        transper: true,
                        color: Colors.white,
                        onPressed: () {},
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: 'Войти',
                        color: const Color(0xFFF6B402),
                        onPressed: () {
                          authPopUp(context);
                        },
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/auth_background.jpeg'),
          fit: BoxFit
              .cover, // This property ensures the image covers the whole screen
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 94.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/images/logo_full.png',
          ),
        ),
      ),
    );
  }
}
