import 'package:cocktails/pages/welcome_page.dart';
import 'package:cocktails/theme/themes.dart';
import 'package:cocktails/utilities/adaptive_size.dart';
import 'package:flutter/material.dart';
import 'package:cocktails/theme/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SizeConfig().init(context);
        });
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BottomNavigationBloc()),
          ],
          child: MaterialApp(
              title: 'Flutter Demo',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: ThemeMode.system,
              home: const WelcomePage()),
        );
      },
    );
  }
}
