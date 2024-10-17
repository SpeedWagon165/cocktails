import 'package:cocktails/bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import 'package:cocktails/bloc/notification_settings_bloc/notification_settings_bloc.dart';
import 'package:cocktails/bloc/standart_auth_bloc/standart_auth_bloc.dart';
import 'package:cocktails/pages/welcome_page.dart';
import 'package:cocktails/provider/cocktail_auth_repository.dart';
import 'package:cocktails/provider/cocktail_list_get.dart';
import 'package:cocktails/provider/profile_repository.dart';
import 'package:cocktails/theme/themes.dart';
import 'package:cocktails/utilities/adaptive_size.dart';
import 'package:cocktails/widgets/bottom_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/app_start_bloc/app_start_bloc.dart';
import 'bloc/avatar_cubit/avatar_cubit.dart';
import 'bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import 'bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import 'bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import 'bloc/notification_bloc/notification_bloc.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Разрешить только портретную ориентацию
  ]).then((_) {
    runApp(EasyLocalization(
        supportedLocales: const [Locale('en', ''), Locale('ru', '')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', ''),
        startLocale: const Locale('ru', ''),
        child: const MyApp()));
  });
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
              BlocProvider(
                  create: (context) =>
                      CocktailCreationBloc(CocktailRepository())),
              BlocProvider(
                  create: (context) =>
                      IngredientSelectionBloc(CocktailRepository())),
              BlocProvider(
                  create: (context) =>
                      CocktailSelectionBloc(CocktailRepository())),
              BlocProvider(
                create: (context) =>
                    AppBloc(AuthRepository())..add(AppStarted()),
              ),
              BlocProvider(
                  create: (context) => CocktailListBloc(CocktailRepository())
                    ..add(FetchCocktails())),
              BlocProvider(create: (context) => BottomNavigationBloc()),
              BlocProvider(create: (context) => NotificationSettingsBloc()),
              BlocProvider(
                create: (context) => ProfileImageCubit()..loadProfileImage(),
              ),
              BlocProvider(
                  create: (context) => NotificationBloc(CocktailRepository())
                    ..add(LoadNotifications())),
              BlocProvider(
                create: (context) =>
                    ProfileBloc(ProfileRepository())..add(FetchProfile()),
              ),
              BlocProvider(
                create: (context) =>
                    AuthBloc(AuthRepository())..add(CheckAuthStatus()),
              ),
              // BlocProvider(
              //   create: (context) => SupportBloc(SupportRepository()),
              // ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: ThemeMode.light,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: WillPopScope(
                onWillPop: () async {
                  // Проверяем, можно ли выполнить pop
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                    return Future.value(false); // Не выходим из приложения
                  } else {
                    return Future.value(true); // Выходим из приложения
                  }
                },
                child: BlocBuilder<AppBloc, AppState>(
                  builder: (context, state) {
                    if (state is AppInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AppAuthenticated) {
                      return const CustomBottomNavigationBar();
                    } else if (state is AppUnauthenticated) {
                      return const WelcomePage();
                    } else {
                      return const Center(
                        child: Text('Unexpected state!'),
                      );
                    }
                  },
                ),
              ),
            ));
      },
    );
  }

  Future<bool> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }
}
