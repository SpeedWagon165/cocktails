import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:cocktails/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../auth/navigators/registration_navigator.dart';
import '../../auth/popups/auth_pop_up.dart';

void needRegistrationPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: 'Подбор коктеля',
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            Text(
              'Чтобы пользоваться функцией “Подобрать коктейль” нужно быть зарегистрированным пользователем',
              style: context.text.bodyText12Grey
                  .copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomButton(
                text: 'Зарегестрироваться',
                single: true,
                gradient: true,
                onPressed: () {
                  Navigator.pop(context);
                  authPopUp(context);
                }),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
