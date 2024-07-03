import 'package:aura_box/aura_box.dart';
import 'package:cocktails/pages/home/popups/cocktail_selection_pop_up.dart';
import 'package:cocktails/widgets/home/info_tile_home.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/home/search_bar_widget.dart';
import 'popups/need_registration_pop_up.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          AssetImage('assets/images/auth_background.jpeg'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Привет, Ирина!',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            CustomRegistrationButton()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: Colors.white.withOpacity(0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color(0xff343434),
                      width: 1.0,
                    ),
                  ),
                  child: const Column(
                    children: [
                      InfoTileHome(
                        icon: 'assets/images/gift_icon.svg',
                        title: 'Мои баллы',
                        subtitle: '150 баллов',
                      ),
                      Divider(color: Color(0xff343434), height: 1),
                      InfoTileHome(
                        icon: 'assets/images/cocktail_icon.svg',
                        title: 'Мои коктейли',
                        subtitle: '20 рецептов',
                      ),
                      Divider(color: Color(0xff343434), height: 1),
                      InfoTileHome(
                        icon: 'assets/images/heart_icon.svg',
                        title: 'Избранное',
                        subtitle: '40 избранных',
                      ),
                      Divider(color: Color(0xff343434), height: 1),
                      InfoTileHome(
                        icon: 'assets/images/mail_icon.svg',
                        title: 'Уведомления',
                        subtitle: '3 новых',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 51),
                CustomButton(
                  text: 'Подобрать коктейль',
                  onPressed: () {
                    cocktailSelectionPopUp(context);
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
