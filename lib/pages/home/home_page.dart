import 'package:cocktails/pages/home/popups/cocktail_selection_pop_up.dart';
import 'package:cocktails/pages/home/popups/need_registration_pop_up.dart';
import 'package:cocktails/widgets/home/info_tile_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/home/search_bar_widget.dart';
import '../auth/popups/auth_pop_up.dart';
import '../bonus_page/bonus_screen.dart';
import '../cocktail_list/cocktail_list_page.dart';
import 'favorite_cocktails_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Инициализация: проверяем авторизацию пользователя
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                const CustomSearchBar(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const ProfileAvatar(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Используем BlocBuilder для проверки состояния авторизации
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                if (authState is AuthAuthenticated) {
                                  // Если пользователь авторизован
                                  return BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, profileState) {
                                      String name = 'Привет!';

                                      if (profileState is ProfileLoaded) {
                                        final profile =
                                            profileState.profileData;
                                        final firstName =
                                            profile['first_name'] ?? 'Привет!';
                                        name = 'Привет, $firstName!';
                                      }

                                      return Text(
                                        name,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // Если пользователь не авторизован
                                  return const Text(
                                    'Привет!',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthUnauthenticated) {
                                  return CustomRegistrationButton(
                                    text: 'Зарегистрироваться',
                                    onTap: () {
                                      authPopUp(context);
                                    },
                                    haveIcon: false,
                                  );
                                } else {
                                  return Container(); // Если авторизован, ничего не показываем
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthAuthenticated) {
                      // Показываем карточку с баллами и другой информацией только для авторизованных пользователей
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
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, profileState) {
                                String points =
                                    '0 баллов'; // Значение по умолчанию

                                if (profileState is ProfileLoaded) {
                                  final profile = profileState.profileData;

                                  // Проверяем, является ли 'points' целым числом и извлекаем данные
                                  final pointsCount = profile['points'];

                                  if (pointsCount is int) {
                                    points = '$pointsCount баллов';
                                  } else {
                                    print(
                                        'Invalid structure for points: $pointsCount');
                                  }
                                }

                                return InfoTileHome(
                                  icon: 'assets/images/gift_icon.svg',
                                  title: 'Мои баллы',
                                  subtitle: points,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BonusScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Divider(color: Color(0xff343434), height: 1),
                            InfoTileHome(
                              icon: 'assets/images/cocktail_icon.svg',
                              title: 'Мои коктейли',
                              subtitle: '20 рецептов',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const MyCocktailsListPage()));
                              },
                            ),
                            const Divider(color: Color(0xff343434), height: 1),
                            InfoTileHome(
                              icon: 'assets/images/heart_icon.svg',
                              title: 'Избранное',
                              subtitle: '40 избранных',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const FavoriteCocktailsPage()));
                              },
                            ),
                            const Divider(color: Color(0xff343434), height: 1),
                            InfoTileHome(
                              icon: 'assets/images/mail_icon.svg',
                              title: 'Уведомления',
                              subtitle: '3 новых',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const BonusScreen()));
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 300,
                      ); // Если пользователь не авторизован, не показываем карточку
                    }
                  },
                ),
                const SizedBox(height: 51),
                CustomButton(
                  text: 'Подобрать коктейль',
                  onPressed: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      cocktailSelectionPopUp(context);
                    } else {
                      needRegistrationPopUp(context);
                    }
                  },
                  single: true,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// gradient: RadialGradient(
//   center: const Alignment(0.6, -1.3), // Центр градиента
//   radius: 1.0, // Радиус градиента
//   colors: [
//     Color(0xFFE76E24).withOpacity(1.0), // Полностью непрозрачный
//     Color(0xFFE76E24).withOpacity(0.45),
//     Color(0xFFE76E24).withOpacity(0.4),
//     Color(0xFFE76E24).withOpacity(0.35),
//     Color(0xFFE76E24).withOpacity(0.3),
//     Color(0xFFE76E24).withOpacity(0.25),
//     Color(0xFFE76E24).withOpacity(0.2),
//     Color(0xFFE76E24).withOpacity(0.15),
//     Color(0xFFE76E24).withOpacity(0.1),
//     Color(0xFFE76E24).withOpacity(0.05),
//   ],)
// Позиции цветов
