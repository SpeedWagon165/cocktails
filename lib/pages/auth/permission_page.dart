import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth/permission_widget.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';
import '../home/home_page.dart';

class RegistrationPage5 extends StatelessWidget {
  final PageController pageController;

  const RegistrationPage5({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: 'Доступ',
      arrow: false,
      onPressed: () {
        pageController.animateToPage(2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PermissionWidget(
            text: 'Для создания и добавления фото',
            headLineText: 'Камера',
            svg: 'assets/images/camera_icon.svg',
          ),
          const SizedBox(
            height: 24,
          ),
          const PermissionWidget(
            text: 'Чтобы не пропустить важное',
            headLineText: 'Уведомления',
            svg: 'assets/images/notifications_icon.svg',
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    text: 'Отказатся',
                    grey: true,
                    onPressed: () {},
                    single: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    text: 'Подтвердить',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
