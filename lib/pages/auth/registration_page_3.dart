import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/user_agreement.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../utilities/data_formater.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_switcher.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage3 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final Function(
    String,
    String,
    String,
    String,
    String,
  ) onPersonalInfoEntered;

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

  String? firstNameError;
  String? birthdateError;
  String? generalError;
  String? phoneError;

  bool isAgreementChecked = false;
  bool isPrivacyChecked = false;

  // Функция для проверки возраста (18 лет)
  bool _isUser18OrOlder(String birthdate) {
    try {
      final birthDate = DateFormat('dd.MM.yyyy').parse(birthdate);
      final today = DateTime.now();
      final age = today.year - birthDate.year;
      return age > 18 ||
          (age == 18 && today.isAfter(birthDate.add(Duration(days: 365 * 18))));
    } catch (e) {
      return false; // Если не удалось распознать дату
    }
  }

  bool _isPhoneNumberValid(String phone) {
    final RegExp phoneRegExp = RegExp(r'^\d+$');
    return phoneRegExp.hasMatch(phone);
  }

  // Функция для отправки формы
  void _onSubmit() {
    setState(() {
      firstNameError = null;
      birthdateError = null;
      generalError = null;
      phoneError = null;
    });

    final firstName = _firstNameController.text;
    final birthdate = _birthdateController.text;
    final phoneNumber = _phoneController.text;

    bool isValid = true;

    // Проверка на пустое имя
    if (firstName.isEmpty) {
      setState(() {
        firstNameError = 'Введите имя';
      });
      isValid = false;
    }

    // Проверка на пустую дату рождения и возраст
    if (birthdate.isEmpty) {
      setState(() {
        birthdateError = 'Введите дату рождения';
      });
      isValid = false;
    } else if (!_isUser18OrOlder(birthdate)) {
      setState(() {
        birthdateError = 'Вам должно быть не менее 18 лет';
      });
      isValid = false;
    }
    if (phoneNumber.isNotEmpty && !_isPhoneNumberValid(phoneNumber)) {
      setState(() {
        phoneError = 'Номер телефона должен содержать только цифры';
      });
      isValid = false;
    }

    // Проверка, что согласия приняты
    if (!isAgreementChecked || !isPrivacyChecked) {
      setState(() {
        generalError = 'Необходимо принять условия соглашений';
      });
      isValid = false;
    }

    // Если все поля валидны
    if (isValid) {
      widget.onPersonalInfoEntered(
        _firstNameController.text,
        _lastNameController.text,
        formatPhoneNumber(_phoneController.text),
        _selectedGender,
        formatDate(_birthdateController.text),
      );
      widget.pageController.animateToPage(3,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

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
          setState(() {
            generalError = 'Некорректные данные для регистрации';
          });
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
                errorMessage: firstNameError, // Отображаем ошибку имени
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
                errorMessage: phoneError,
              ),
              CustomTextField(
                labelText: 'Дата рождения*',
                controller: _birthdateController,
                isJoined: true,
                isDate: true,
                joinPosition: JoinPosition.none,
                errorMessage: birthdateError, // Отображаем ошибку даты рождения
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
              UserAgreement(
                text:
                    'Даю согласие на обработку персональных данных в соответствии с ',
                clickText: 'пользовательским соглашением.',
                onCheckChanged: (checked) {
                  setState(() {
                    isAgreementChecked = checked;
                  });
                },
              ),
              const SizedBox(height: 12),
              UserAgreement(
                text: 'Принимаю условия ',
                clickText: 'политики конфиденциальности.',
                onCheckChanged: (checked) {
                  setState(() {
                    isPrivacyChecked = checked;
                  });
                },
              ),
              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    generalError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Далее',
                onPressed: _onSubmit, // Валидация и отправка данных
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
