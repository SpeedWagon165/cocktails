import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utilities/language_swich.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportedLocales = context.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Select Language', style: context.text.bodyText16White).tr(),
      ),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          return ListTile(
            title: Text(
              locale.languageCode.toUpperCase(),
              style: context.text.bodyText16White,
            ),
            onTap: () async {
              // Меняем локализацию
              context.setLocale(locale);

              // Сохраняем выбранный язык в SharedPreferences
              String selectedLanguage =
                  locale.languageCode == 'ru' ? 'rus' : 'eng';
              await LanguageService.saveLanguage(selectedLanguage);

              // Возвращаемся назад после выбора языка
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
