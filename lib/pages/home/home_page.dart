import 'package:cocktails/widgets/home/info_tile_home.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/home/search_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 22,
            ),
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
                Column(
                  children: [
                    Text(
                      'Привет, Ирина!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                  )),
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
              onPressed: () {},
              single: true,
            ),
          ],
        ),
      ),
    );
  }
}
