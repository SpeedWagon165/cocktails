import 'package:cocktails/pages/account/privacy_policy_page.dart';
import 'package:cocktails/pages/account/terms_use_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/account/about_app_tile.dart';
import '../../widgets/custom_arrowback.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'О приложении',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 42,
            ),
            Card(
              color: Colors.white.withOpacity(0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xff343434),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  AboutAppTile(
                    title: 'Политика конфиденциальности',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage()));
                    },
                  ),
                  const Divider(color: Color(0xff343434), height: 1),
                  AboutAppTile(
                    title: 'Пользовательское соглашение',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TermsUsePage()));
                    },
                  ),
                  const Divider(color: Color(0xff343434), height: 1),
                  AboutAppTile(
                    title: 'Версия приложения',
                    onTap: () {},
                    version: false,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
