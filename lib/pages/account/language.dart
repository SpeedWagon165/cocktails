import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportedLocales = context.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language', style: context.text.bodyText16White)
            .tr(), // Используем локализацию
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
            // Отображаем код языка
            onTap: () {
              // Меняем локализацию при нажатии
              context.setLocale(locale);
              Navigator.pop(context); // Закрываем страницу после выбора
            },
          );
        },
      ),
    );
  }
}
