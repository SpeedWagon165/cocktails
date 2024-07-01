import 'package:cocktails/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xff0E0E0E),
    extensions: <ThemeExtension<dynamic>>[
      AppTextStyles.light,
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xff0E0E0E),
    extensions: <ThemeExtension<dynamic>>[
      AppTextStyles.dark,
    ],
  );
}
