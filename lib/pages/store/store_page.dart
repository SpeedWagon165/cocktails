import 'package:cocktails/pages/store/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/goods_bloc/goods_bloc.dart';
import '../../provider/store_repository.dart';
import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => GoodsBloc(GoodsRepository())..add(FetchGoods()),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
            child: Column(
              children: [
                CustomAppBar(
                  text: tr('store.title'), // локализованная строка
                  arrow: false,
                  auth: false,
                  onPressed: null,
                ),
                const SizedBox(height: 16),
                const CustomSearchBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<GoodsBloc, GoodsState>(
                    builder: (context, state) {
                      if (state is GoodsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GoodsLoaded) {
                        return ListView.builder(
                          itemCount: state.goods.length,
                          itemBuilder: (context, index) {
                            final product = state.goods[index];
                            final minPrice = _getMinPrice(product.links);
                            return ProductCard(
                              name: product.name ??
                                  tr("store.default_product_name"),
                              imageUrl: product.photo ?? '',
                              price: minPrice,
                              product: product,
                            );
                          },
                        );
                      } else if (state is GoodsError) {
                        return Center(child: Text(tr('errors.server_error')));
                      }
                      return Center(child: Text(tr('store.empty_message')));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getMinPrice(Map<String, dynamic>? links) {
    if (links == null || links.isEmpty) {
      return 0.0; // Если ссылки пусты или null, возвращаем 0
    }

    final prices = links.values
        .where((link) =>
            link is Map<String, dynamic> && // Проверяем, что link - это Map
            link.containsKey('price') && // Проверяем наличие ключа 'price'
            link['price'] != null && // Проверяем, что значение не null
            double.tryParse(link['price'].toString()) !=
                null) // Проверяем корректность данных
        .map((link) =>
            double.parse(link['price'].toString())) // Преобразуем в double
        .toList();

    prices.sort();
    return prices.isNotEmpty ? prices.first : 0.0;
  }
}
// final List<String> categories = [
//   'Бочонки',
//   'Дымные наборы',
//   'Набор 17 предмет',
//   'Вино',
//   'Вино шотланское'
// ];
//     SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: categories.map((category) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Chip(
//               backgroundColor: Color(0xff212121),
//               label: Text(
//                 category,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//               shape: const StadiumBorder(
//                 side: BorderSide(color: Color(0xff343434)),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     ),
