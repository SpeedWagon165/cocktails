import 'package:flutter/material.dart';

import '../../../widgets/auth/custom_registration_button.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/store/expandable_text.dart';

void productPagePopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: 'Хайбол "Casablanca", 365 ml',
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/1aa3b101bb92d5754f486009f6cc29b6.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const ExpandableTextWidget(
              text:
                  "Это освежающий сладкий лонг на основе рома с большим количеством мяты и лайма. Кстати, когда-то их добавляли для того, чтобы перебить вкус плохого рома и обезопасить напиток от порчи. Но сегодня этот коктейль стал одной из любимых классических позиций.итгывиаыгаиывгиаывгиаиываиывиаиыугиагуыинагнывиагрыиугнсиуынгиагныуисгниуыа",
              titleText: 'Описание',
            ),
            const SizedBox(
              height: 24,
            ),
            RegistrationServicesButton(
              text: 'Купить на Wildberries  ',
              trailingText: '4000 ₽',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 12,
            ),
            RegistrationServicesButton(
              text: 'Купить на Ozon  ',
              trailingText: '3500 ₽',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 12,
            ),
            RegistrationServicesButton(
              text: 'Купить на Яндекс Маркет  ',
              trailingText: '3000 ₽',
              onPressed: () {
                Navigator.of(context).pop();
              },
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
