import 'package:cocktails/widgets/home/create_cocktail_widgets/gradient_add_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';
import 'new_recipe/new_recipe_page.dart';

class MyCocktailsListPage extends StatefulWidget {
  const MyCocktailsListPage({super.key});

  @override
  State<MyCocktailsListPage> createState() => _MyCocktailsListPageState();
}

class _MyCocktailsListPageState extends State<MyCocktailsListPage> {
  late final CocktailListBloc _bloc;
  String? token;

  @override
  void initState() {
    super.initState();
    _bloc = CocktailListBloc(CocktailRepository());
    _loadToken();
  }

  // Получение токена из SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });

    if (token != null) {
      // Загружаем коктейли пользователя
      _bloc.add(FetchUserCocktails(token!));
    } else {
      // Логика, если токен отсутствует, например, перенаправление на страницу входа
      print('Token not found. Redirect to login or handle error.');
      _bloc.add(FetchCocktails()); // Опционально можно показать общие коктейли
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<CocktailListBloc, CocktailListState>(
            builder: (context, state) {
              int cocktailCount = 0;
              Widget content;

              // Обрабатываем различные состояния блока
              if (state is CocktailLoading) {
                content = const Center(child: CircularProgressIndicator());
              } else if (state is CocktailLoaded) {
                cocktailCount = state.cocktails.length;

                if (state.cocktails.isEmpty) {
                  content = Center(
                    child: Text(tr(
                        'my_cocktails_page.no_cocktails')), // Локализация сообщения
                  );
                } else {
                  content = RefreshIndicator(
                    onRefresh: () async {
                      if (token != null) {
                        _bloc.add(FetchUserCocktails(token!));
                      }
                    },
                    child: ListView.builder(
                      itemCount: state.cocktails.length,
                      itemBuilder: (context, index) {
                        return CocktailCard(cocktail: state.cocktails[index]);
                      },
                    ),
                  );
                }
              } else if (state is CocktailError) {
                content = Center(
                    child:
                        Text(tr('errors.server_error'))); // Локализация ошибки
              } else {
                content = Center(
                  child: Text(tr(
                      'my_cocktails_page.start_search')), // Локализация сообщения
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
                child: Column(
                  children: [
                    CustomAppBar(
                      text: tr('my_cocktails_page.title',
                          namedArgs: {'count': cocktailCount.toString()}),
                      // Локализация заголовка
                      onPressed: null,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Expanded(child: CustomSearchBar()),
                        const SizedBox(width: 8),
                        GradientAddButton(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const NewRecipePage()));
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: content),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
