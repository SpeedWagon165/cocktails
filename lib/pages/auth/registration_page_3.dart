import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/user_agreement.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_switcher.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage3 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final Function(String, String, String, String, String) onPersonalInfoEntered;

  const RegistrationPage3({
    super.key,
    required this.pageController,
    required this.email,
    required this.onPersonalInfoEntered,
  });

  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  String _selectedGender = 'Male'; // Default gender value

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserRegistered) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavigationBar(),
            ),
          );
        } else if (state is AuthError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: 'Регистрация',
          onPressed: () {
            widget.pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                labelText: 'Имя*',
                controller: _firstNameController,
                isJoined: true,
                joinPosition: JoinPosition.top,
              ),
              CustomTextField(
                labelText: 'Фамилия',
                controller: _lastNameController,
                isJoined: true,
                joinPosition: JoinPosition.none,
              ),
              CustomTextField(
                labelText: 'Номер телефона',
                controller: _phoneController,
                isJoined: true,
                phoneNumber: true,
                joinPosition: JoinPosition.none,
              ),
              CustomTextField(
                labelText: 'Дата рождения',
                controller: _birthdateController,
                isJoined: true,
                isDate: true,
                joinPosition: JoinPosition.none,
              ),
              const CustomTextField(
                labelText: 'Номер реферала',
                isJoined: true,
                isReferral: true,
                joinPosition: JoinPosition.bottom,
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ваш пол',
                  style: context.text.bodyText16White,
                ),
              ),
              const SizedBox(height: 12),
              GradientBorderSwitch(
                onGenderChanged: (gender) {
                  _selectedGender = gender; // Обновляем выбранный пол
                },
              ),
              const SizedBox(height: 24),
              const UserAgreement(
                text:
                    'Даю согласие на обработку персональных данных в соответствии с ',
                clickText: 'пользовательским соглашением.',
              ),
              const SizedBox(height: 12),
              const UserAgreement(
                text: 'Принимаю условия ',
                clickText: 'политики конфиденциальности.',
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Далее',
                onPressed: () {
                  context.read<AuthBloc>().add(
                        RegisterRequested(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          gender: _selectedGender,
                          dateOfBirth: _birthdateController.text,
                          password:
                              "", // Нужно добавить поле для пароля на следующей странице
                        ),
                      );
                  widget.pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                single: true,
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
