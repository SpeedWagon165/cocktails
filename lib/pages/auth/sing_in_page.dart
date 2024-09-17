import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../provider/cocktail_auth_repository.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class SignInPage extends StatefulWidget {
  final PageController pageController;

  const SignInPage({
    super.key,
    required this.pageController,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Переменные для хранения ошибок
  String? usernameError;
  String? passwordError;
  String? generalError;

  void _onSubmit(BuildContext context) {
    // Сброс ошибок перед валидацией
    setState(() {
      usernameError = null;
      passwordError = null;
      generalError = null;
    });

    bool usernameIsEmpty = usernameController.text.isEmpty;
    bool passwordIsEmpty = passwordController.text.isEmpty;

    // Если оба поля пусты, показываем только generalError
    if (usernameIsEmpty && passwordIsEmpty) {
      setState(() {
        generalError = 'Введите электронную почту и пароль';
      });
    } else {
      // Если одно из полей пусто, показываем соответствующую ошибку для поля
      if (usernameIsEmpty) {
        setState(() {
          usernameError = 'Введите электронную почту';
        });
      }
      if (passwordIsEmpty) {
        setState(() {
          passwordError = 'Введите пароль';
        });
      }
    }

    // Если оба поля заполнены и нет общей ошибки, отправляем запрос
    if (!usernameIsEmpty && !passwordIsEmpty && generalError == null) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(
          usernameController.text,
          passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: BasePopup(
        text: 'Вход',
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Builder(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: usernameController,
                        labelText: 'Электронная почта',
                        isJoined: true,
                        joinPosition: JoinPosition.top,
                        errorMessage:
                            generalError != null ? ' ' : usernameError,
                        // Подсвечиваем поле при общей ошибке
                        showRedBorder: generalError !=
                            null, // Принудительно подсвечиваем границу поля
                      ),
                      CustomTextField(
                        controller: passwordController,
                        labelText: 'Пароль',
                        obscureText: true,
                        isJoined: true,
                        joinPosition: JoinPosition.bottom,
                        errorMessage:
                            generalError != null ? ' ' : passwordError,
                        // Подсвечиваем поле при общей ошибке
                        showRedBorder: generalError !=
                            null, // Принудительно подсвечиваем границу поля
                      ),
                    ],
                  ),
                ),
                Align(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      generalError != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                generalError!,
                                style: context.text.bodyText14White
                                    .copyWith(color: Colors.red),
                              ),
                            )
                          : const SizedBox(),
                      TextButton(
                        onPressed: () {
                          widget.pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 3),
                              curve: Curves.easeInOut);
                        },
                        child: Text(
                          'Забыли пароль?',
                          style: context.text.bodyText12Grey
                              .copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AuthAuthenticated) {
                      Navigator.of(context).pop(); // Закрываем окно загрузки
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CustomBottomNavigationBar()),
                      );
                    } else if (state is AuthError) {
                      Navigator.of(context).pop(); // Закрываем окно загрузки

                      // Если ошибка связана с неправильным логином или паролем
                      if (state.message.contains('400')) {
                        setState(() {
                          generalError = 'Неверный логин или пароль';
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Войти',
                      onPressed: () {
                        _onSubmit(context); // Валидация и отправка
                      },
                      single: true,
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                const TextWithLines(text: 'или с помощью'),
                const SizedBox(height: 24),
                RegistrationServicesButton(text: 'Apple ID', onPressed: () {}),
                const SizedBox(height: 12),
                RegistrationServicesButton(text: 'Google', onPressed: () {}),
                const SizedBox(height: 12),
                RegistrationServicesButton(text: 'Facebook', onPressed: () {}),
                const SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {
                    widget.pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: Text('Зарегистрироваться',
                      style: context.text.bodyText16White),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
