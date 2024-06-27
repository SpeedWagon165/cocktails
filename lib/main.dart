import 'package:cocktails/pages/auth/sing_in_page.dart';
import 'package:cocktails/utilities/adaptive_size.dart';
import 'package:flutter/material.dart';
import 'package:cocktails/theme/styles.dart';

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
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            extensions: [AppTextStyles.light],
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            extensions: [AppTextStyles.dark],
          ),
          home: const SignInPage(),
        );
      },
    );
  }
}
