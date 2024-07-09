import 'package:cocktails/pages/store/product_card.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_arrowback.dart';
import '../../widgets/home/search_bar_widget.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Бочонок тёмный',
        'imageUrl': 'assets/images/1aa3b101bb92d5754f486009f6cc29b6.jpeg',
        'price': 4000.0,
      },
      {
        'name': 'Бочонок светлый',
        'imageUrl': 'assets/images/18d69d8a15af86ee1c05a22baf387939.jpeg',
        'price': 4000.0,
      }
    ];
    final List<String> categories = [
      'Бочонки',
      'Дымные наборы',
      'Набор 17 предмет',
      'Вино',
      'Вино шотланское'
    ];
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Column(children: [
        const CustomArrowBack(
          text: 'Магазин',
          arrow: false,
          auth: false,
          onPressed: null,
        ),
        const SizedBox(
          height: 16,
        ),
        const CustomSearchBar(),
        const SizedBox(
          height: 16,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Chip(
                  backgroundColor: Color(0xff212121),
                  label: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  shape: const StadiumBorder(
                    side: BorderSide(color: Color(0xff343434)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                name: product['name'],
                imageUrl: product['imageUrl'],
                price: product['price'],
              );
            },
          ),
        ),
      ]),
    )));
  }
}
