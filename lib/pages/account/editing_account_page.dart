import 'package:cocktails/pages/account/popups/exit_account_pop_up.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../widgets/account/account_information_widget.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_arrowback.dart';

class EditingAccountPage extends StatefulWidget {
  const EditingAccountPage({super.key});

  @override
  State<EditingAccountPage> createState() => _EditingAccountPageState();
}

class _EditingAccountPageState extends State<EditingAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Редактирование',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 24,
            ),
            const Center(
              child: CircleAvatar(
                radius: 55,
                backgroundImage:
                    AssetImage('assets/images/auth_background.jpeg'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: CustomRegistrationButton(
                text: 'Загрузить фото',
                icon: 'assets/images/upload_icon.svg',
                onTap: () {},
                haveIcon: true,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const AccountInformationWidget(
              labelText: 'Имя',
              infoText: 'Ирина',
              joinPosition: JoinPosition.top,
              isJoined: true,
            ),
            const AccountInformationWidget(
              labelText: 'Фамилия',
              infoText: 'Мякушкина',
              joinPosition: JoinPosition.none,
              isJoined: true,
            ),
            const AccountInformationWidget(
              labelText: 'Эл. почта',
              infoText: 'irina_ivanova@gmail.com',
              joinPosition: JoinPosition.none,
              isJoined: true,
            ),
            const AccountInformationWidget(
              labelText: 'Пол',
              infoText: 'женский',
              joinPosition: JoinPosition.none,
              isJoined: true,
            ),
            const AccountInformationWidget(
              labelText: 'Дата рождения',
              infoText: '01.01.2000',
              joinPosition: JoinPosition.bottom,
              isJoined: true,
            ),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  exitAccount(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: const Color(0xFFFF4747).withOpacity(0.5),
                      width: 1.3,
                    )),
                child: Text(
                  'Выйти из аккаунта',
                  style: context.text.bodyText16White.copyWith(fontSize: 15),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
