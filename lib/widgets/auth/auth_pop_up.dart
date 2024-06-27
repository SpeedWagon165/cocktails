import 'package:cocktails/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../custom_arrowback.dart';
import 'custom_auth_textfield.dart';

void authPopUp(BuildContext context, {String? initialText}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: const Color(0xFF1C1615),
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E0E0E), Color(0xFF251511)],
            // Ваши цвета градиента
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        width: 42.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                            color: const Color(0xFF343434),
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CustomArrowBack(text: 'Вход'),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const CustomTextField(
                      labelText: 'Электронная почта',
                      isJoined: true,
                      joinPosition: JoinPosition.top,
                    ),
                    const CustomTextField(
                      labelText: 'Пароль',
                      obscureText: true,
                      isJoined: true,
                      joinPosition: JoinPosition.bottom,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Забыли пароль?',
                            style: TextStyle(fontSize: 14),
                          )),
                    ),
                    CustomButton(
                      text: 'Войти',
                      color: const Color(0xFFF6B402),
                      onPressed: () {
                        authPopUp(context);
                      },
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
