import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/custom_button.dart';
import '../../welcome_page.dart';

void exitAccount(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: 'Выход',
        arrow: false,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            Text(
              'Вы уверены, что хотите выйти из приложения?',
              style: context.text.bodyText12Grey
                  .copyWith(fontSize: 16, height: 1.5),
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
                      text: 'Выйти',
                      grey: true,
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(SignOutRequested());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()),
                          (route) => false,
                        );
                      },
                      single: false,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: CustomButton(
                      text: 'Отмена',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      single: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
