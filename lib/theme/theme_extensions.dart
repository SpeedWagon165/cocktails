import 'package:cocktails/theme/styles.dart';
import 'package:flutter/material.dart';

extension ThemeTextStylesExtension on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}
