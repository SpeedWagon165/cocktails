import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/account/info_tile_account.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_arrowback.dart';
import '../auth/popups/auth_pop_up.dart';
import '../bonus_page/bonus_screen.dart';
import 'about_app_page.dart';
import 'change_password/change_password_step_1.dart';
import 'editing_account_page.dart';
import 'notification_settings_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

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
                  const ProfileAvatar(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          if (authState is AuthAuthenticated) {
                            // Если пользователь авторизован, показываем имя и кнопку "Редактировать"
                            return BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                String fullName = 'Нет данных';

                                if (state is ProfileLoaded) {
                                  final profile = state.profileData;
                                  final firstName =
                                      profile['first_name'] ?? 'Нет данных';
                                  final lastName = profile['last_name'] ?? '';

                                  fullName = lastName.isNotEmpty
                                      ? '$firstName $lastName'
                                      : firstName;
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    CustomRegistrationButton(
                                      text: 'Редактировать',
                                      icon: 'assets/images/pen_icon.svg',
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditingAccountPage(),
                                          ),
                                        );
                                      },
                                      haveIcon: true,
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Если пользователь не авторизован, показываем кнопку "Зарегистрироваться"
                            return CustomRegistrationButton(
                              text: 'Зарегистрироваться',
                              onTap: () {
                                authPopUp(context);
                              },
                              haveIcon: false,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthAuthenticated) {
                    return Card(
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
                                  builder: (context) =>
                                      const ChangePasswordStep1()));
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
                    );
                  } else {
                    // Если пользователь не авторизован, показываем ограниченное меню
                    return Card(
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
                            icon: 'assets/images/about_app_icon.svg',
                            title: 'О приложении',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AboutAppPage()));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
