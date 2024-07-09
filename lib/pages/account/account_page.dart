import 'package:flutter/material.dart';

import '../../widgets/account/info_tile_account.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_arrowback.dart';
import '../bonus_page/bonus_screen.dart';
import 'about_app_page.dart';
import 'change_password/change_password_step_1.dart';
import 'editing_account_page.dart';
import 'notification_settings_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14),
          child: Column(
            children: [
              const CustomArrowBack(
                text: 'Аккаунт',
                arrow: false,
                auth: false,
                onPressed: null,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        AssetImage('assets/images/auth_background.jpeg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 35.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ирина Иванова',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          CustomRegistrationButton(
                            text: 'Редактировать',
                            icon: 'assets/images/pen_icon.svg',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const EditingAccountPage()));
                            },
                            haveIcon: true,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
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
                    InfoTileAccount(
                      icon: 'assets/images/language_icon.svg',
                      title: 'Язык',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BonusScreen()));
                      },
                    ),
                    const Divider(color: Color(0xff343434), height: 1),
                    InfoTileAccount(
                      icon: 'assets/images/pass_change_icon.svg',
                      title: 'Пароль',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChangePasswordStep1()));
                      },
                    ),
                    const Divider(color: Color(0xff343434), height: 1),
                    InfoTileAccount(
                      icon: 'assets/images/ion_mail-notification.svg',
                      title: 'Уведомления',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const NotificationSetupPage()));
                      },
                    ),
                    const Divider(color: Color(0xff343434), height: 1),
                    InfoTileAccount(
                      icon: 'assets/images/contact-support_icon.svg',
                      title: 'Связатся с поддержкой',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BonusScreen()));
                      },
                    ),
                    const Divider(color: Color(0xff343434), height: 1),
                    InfoTileAccount(
                      icon: 'assets/images/about_app_icon.svg',
                      title: 'О приложении',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AboutAppPage()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
