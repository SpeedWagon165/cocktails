import 'dart:io';

import 'package:cocktails/pages/account/popups/exit_account_pop_up.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../bloc/avatar_cubit/avatar_cubit.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../provider/profile_repository.dart';
import '../../utilities/language_swich.dart';
import '../../widgets/account/account_information_widget.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_arrowback.dart';

class EditingAccountPage extends StatefulWidget {
  const EditingAccountPage({super.key});

  @override
  State<EditingAccountPage> createState() => _EditingAccountPageState();
}

class _EditingAccountPageState extends State<EditingAccountPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _savedImagePath;
  late final ProfileBloc _profileBloc;
  String _language = 'rus';

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(ProfileRepository());
    _profileBloc.add(FetchProfile());
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = await LanguageService.getLanguage();
    if (mounted) {
      setState(() {
        _language = language;
      });
    }
  }

  // Функция для уменьшения размера изображения
  Future<File> reduceImageSize(File imageFile) async {
    // Чтение изображения
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    // Изменение размера изображения
    img.Image resizedImage = img.copyResize(image!, width: 300);

    // Кодирование изображения в JPEG с качеством 70
    File resizedFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 70));

    return resizedFile;
  }

  String getLocalizedGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return _language == 'rus' ? 'Мужчина' : 'Male';
      case 'female':
        return _language == 'rus' ? 'Женщина' : 'Female';
      default:
        return gender;
    }
  }

  // Функция для выбора изображения с камеры или галереи
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Уменьшение размера изображения перед сохранением (опционально)
      File resizedFile = await reduceImageSize(imageFile);

      // Сохраняем изображение через Cubit
      context.read<ProfileImageCubit>().setProfileImage(resizedFile.path);

      setState(() {
        _image = resizedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: BlocProvider(
            create: (_) => _profileBloc,
            child: Column(children: [
              CustomAppBar(
                text: tr('edit_profile_page.title'),
                // Локализованная строка "Редактирование"
                arrow: true,
                auth: false,
                onPressed: null,
              ),
              const SizedBox(height: 24),
              const Center(
                child: ProfileAvatar(),
              ),
              const SizedBox(height: 15),
              IntrinsicWidth(
                child: CustomRegistrationButton(
                  text: tr('edit_profile_page.upload_photo'),
                  // Локализованная строка "Загрузить фото"
                  icon: 'assets/images/upload_icon.svg',
                  onTap: _pickImage,
                  haveIcon: true,
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String firstName = 'Нет данных';
                  String lastName = 'Нет данных';
                  String email = 'Нет данных';
                  String gender = 'Нет данных';
                  String dateOfBirth = 'Нет данных';

                  if (state is ProfileLoaded) {
                    final profile = state.profileData;
                    firstName = profile['first_name'] ?? 'Нет данных';
                    lastName = profile['last_name'] ?? '';
                    email = profile['email'] ?? 'Нет данных';
                    gender = profile['gender'] ?? 'Нет данных';
                    dateOfBirth = profile['date_of_birth'] ?? 'Нет данных';
                  }

                  return Column(
                    children: [
                      AccountInformationWidget(
                        labelText: tr('edit_profile_page.first_name'),
                        // Локализованная строка "Имя"
                        infoText: firstName,
                        joinPosition: JoinPosition.top,
                        isJoined: true,
                      ),
                      AccountInformationWidget(
                        labelText: tr('edit_profile_page.last_name'),
                        // Локализованная строка "Фамилия"
                        infoText: lastName,
                        joinPosition: JoinPosition.none,
                        isJoined: true,
                      ),
                      AccountInformationWidget(
                        labelText: tr('edit_profile_page.email'),
                        // Локализованная строка "Эл. почта"
                        infoText: email,
                        joinPosition: JoinPosition.none,
                        isJoined: true,
                      ),
                      AccountInformationWidget(
                        labelText: tr('edit_profile_page.gender'),
                        // Локализованная строка "Пол"
                        infoText: getLocalizedGender(gender),
                        joinPosition: JoinPosition.none,
                        isJoined: true,
                      ),
                      AccountInformationWidget(
                        labelText: tr('edit_profile_page.date_of_birth'),
                        // Локализованная строка "Дата рождения"
                        infoText: dateOfBirth,
                        joinPosition: JoinPosition.bottom,
                        isJoined: true,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    exitAccount(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                        color: const Color(0xFFFF4747).withOpacity(0.5),
                        width: 1.3,
                      )),
                  child: Text(
                    tr('edit_profile_page.log_out'),
                    // Локализованная строка "Выйти из аккаунта"
                    style: context.text.bodyText16White.copyWith(fontSize: 15),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
