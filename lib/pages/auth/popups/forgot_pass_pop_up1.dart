import 'package:flutter/material.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import 'auth_pop_up.dart';

void forgotPassPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: const Color(0xFF1C1615),
    builder: (context) {
      return const BasePopup(
        text: 'Вход',
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CustomTextField(
            labelText: 'Электронная почта',
            isJoined: true,
            joinPosition: JoinPosition.top,
          ),
        ]),
      );
    },
  );
}
