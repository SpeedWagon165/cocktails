import 'package:app_links/app_links.dart';
import 'package:cocktails/bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import 'package:cocktails/bloc/notification_settings_bloc/notification_settings_bloc.dart';
import 'package:cocktails/bloc/standart_auth_bloc/standart_auth_bloc.dart';
import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:cocktails/pages/welcome_page.dart';
import 'package:cocktails/provider/cocktail_auth_repository.dart';
import 'package:cocktails/provider/cocktail_list_get.dart';
import 'package:cocktails/provider/notification_repository.dart';
import 'package:cocktails/provider/profile_repository.dart';
import 'package:cocktails/theme/themes.dart';
import 'package:cocktails/utilities/adaptive_size.dart';
import 'package:cocktails/utilities/language_swich.dart';
import 'package:cocktails/widgets/bottom_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_start_bloc/app_start_bloc.dart';
import 'bloc/avatar_cubit/avatar_cubit.dart';
import 'bloc/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import 'bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import 'bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import 'bloc/deep_link_bloc/deep_link_bloc.dart';
import 'bloc/notification_bloc/notification_bloc.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();

  final savedLanguage = await LanguageService.getLanguage();
  final startLocale = savedLanguage == 'rus' ? Locale('ru') : Locale('en');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(EasyLocalization(
        supportedLocales: const [Locale('en', ''), Locale('ru', '')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', ''),
        startLocale: startLocale,
        child: const MainApp()));
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeepLinkNavigationBloc()),
        BlocProvider(
          create: (context) => CocktailCreationBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => IngredientSelectionBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => CocktailSelectionBloc(CocktailRepository()),
        ),
        BlocProvider(
          create: (context) => AppBloc(AuthRepository())..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) =>
              CocktailListBloc(CocktailRepository())..add(FetchCocktails()),
        ),
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(create: (context) => NotificationSettingsBloc()),
        BlocProvider(
          create: (context) => ProfileImageCubit()..loadProfileImage(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(NotificationRepository())
            ..add(LoadNotifications()),
        ),
        BlocProvider(
          create: (context) =>
              ProfileBloc(ProfileRepository())..add(FetchProfile()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  String? _deepLink;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinkListener();
  }

  void _initializeDeepLinkListener() async {
    _appLinks = AppLinks();

    // Слушатель для обработанных ссылок
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Проверка активной ссылки при старте
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.contains('recipe')) {
      final id = uri.pathSegments.last;
      debugPrint(id);
      if (id.isNotEmpty) {
        context.read<CocktailListBloc>().add(FetchCocktailById(int.parse(id)));
        setState(() {
          _deepLink = uri.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SizeConfig().init(context);
        });
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mr. Barmister',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (_deepLink != null) {
                return CocktailCardScreen(
                  cocktailId: int.tryParse(_deepLink!.split('/').last),
                  userId: null,
                );
              } else if (state is AppInitial) {
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
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
