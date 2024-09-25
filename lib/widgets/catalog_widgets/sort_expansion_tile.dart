import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';
import '../custom_checkbox.dart';

class SortExpansionTile extends StatefulWidget {
  final String currentSortOption; // Текущая опция сортировки

  const SortExpansionTile({
    required this.currentSortOption, // Принимаем текущее значение сортировки через конструктор
    super.key,
  });

  @override
  SortExpansionTileState createState() => SortExpansionTileState();
}

class SortExpansionTileState extends State<SortExpansionTile> {
  late String selectedSortOption;

  final List<String> sortOptions = [
    'По алфавиту (А-Я, A-Z)',
    'По алфавиту (Я-А, Z-A)',
    'По наличию видео',
  ];

  @override
  void initState() {
    super.initState();
    // Инициализируем выбранную сортировку из переданного параметра
    selectedSortOption = widget.currentSortOption;
  }

  // Получаем отображаемый заголовок для текущей сортировки
  String _getSortTitle() {
    switch (selectedSortOption) {
      case '-title':
        return 'По алфавиту (Я-А)';
      case 'video_url':
        return 'По наличию видео';
      default:
        return 'По алфавиту (А-Я)';
    }
  }

  // Преобразование отображаемого варианта сортировки в API параметр
  String _mapSortOptionToApiField(String option) {
    switch (option) {
      case 'По алфавиту (Я-А, Z-A)':
        return '-title'; // Обратный порядок
      case 'По наличию видео':
        return 'video_url'; // Сортировка по наличию видео
      default:
        return 'title'; // По алфавиту
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(10.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Убираем разделитель
        ),
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              _getSortTitle(), // Отображаем текущий заголовок сортировки
              style: context.text.bodyText16White,
            ),
          ),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 7.0),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: SizedBox(
                height: 150, // Ограничиваем высоту виджета
                child: ListView.builder(
                  itemCount: sortOptions.length,
                  itemBuilder: (context, index) {
                    final option = sortOptions[index];
                    return CustomCheckboxListTile(
                      title: option,
                      value: selectedSortOption ==
                          _mapSortOptionToApiField(option),
                      // Устанавливаем галочку на текущем выбранном значении
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          setState(() {
                            selectedSortOption = _mapSortOptionToApiField(
                                option); // Обновляем выбранное значение
                          });
                          // Отправляем событие сортировки через блок
                          final sortField = _mapSortOptionToApiField(option);
                          context.read<CocktailListBloc>().add(
                                SearchCocktails(
                                  ordering: sortField,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
