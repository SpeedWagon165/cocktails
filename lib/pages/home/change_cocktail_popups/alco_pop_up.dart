import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/base_pop_up.dart';

void alcoChoicePopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: tr('alcohol_popup.title'), // Локализация заголовка
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Column(
          children: [
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
