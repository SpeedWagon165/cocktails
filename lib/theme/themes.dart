import 'package:cocktails/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    chipTheme: ChipThemeData(
      backgroundColor: Colors.black,
      deleteIconColor: Colors.black,
      disabledColor: Colors.black,
      selectedColor: Colors.black,
      secondarySelectedColor: Colors.black,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.black,
      selectedShadowColor: Colors.black,
    ),
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xff0E0E0E),
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
