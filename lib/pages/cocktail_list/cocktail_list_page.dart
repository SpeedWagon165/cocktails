import 'package:cocktails/widgets/base_appbar.dart';
import 'package:cocktails/widgets/cocktail_list/selected_items_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../../provider/cocktail_list_get.dart';
import '../../widgets/cocktail_list/cocktail_card.dart';

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
        appBar: baseAppBar(
          context,
          'Мои коктейли', // Динамически отображаем количество коктейлей
          true,
          true,
        ),
        body: Column(
          children: [
            SelectedItemsCarousel(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CocktailListBloc, CocktailListState>(
                builder: (context, state) {
                  if (state is CocktailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CocktailLoaded) {
                    if (state.cocktails.isEmpty) {
                      return const Center(
                          child: Text('У вас пока нет коктейлей.'));
                    }
                    return RefreshIndicator(
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
                  } else if (state is CocktailError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Начните поиск рецептов'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
