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

class SignInPage extends StatelessWidget {
  final PageController pageController;

  const SignInPage({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

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
                      ),
                      CustomTextField(
                        controller: passwordController,
                        labelText: 'Пароль',
                        obscureText: true,
                        isJoined: true,
                        joinPosition: JoinPosition.bottom,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        pageController.animateToPage(2,
                            duration: const Duration(milliseconds: 9),
                            curve: Curves.easeInOut);
                      },
                      child: Text(
                        'Забыли пароль?',
                        style:
                            context.text.bodyText12Grey.copyWith(fontSize: 14),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      print('AuthLoading state');
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AuthAuthenticated) {
                      print('AuthAuthenticated state');
                      Navigator.of(context).pop(); // Close the loading dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CustomBottomNavigationBar()),
                      );
                    } else if (state is AuthError) {
                      print('AuthError state: ${state.message}');
                      Navigator.of(context).pop(); // Close the loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Войти',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print(
                              'Form validated, sending SignInRequested event');
                          BlocProvider.of<AuthBloc>(context).add(
                            SignInRequested(
                              usernameController.text,
                              passwordController.text,
                            ),
                          );
                        } else {
                          print('Form validation failed');
                        }
                      },
                      single: true,
                    );
                  },
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const TextWithLines(
                  text: 'или с помощью',
                ),
                const SizedBox(
                  height: 24,
                ),
                RegistrationServicesButton(
                  text: 'Apple ID',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                RegistrationServicesButton(
                  text: 'Google',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                RegistrationServicesButton(
                  text: 'Facebook',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextButton(
                    onPressed: () {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      'Зарегистрироваться',
                      style: context.text.bodyText16White,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
