import 'package:cocktails/pages/cocktail_card_page/cocktail_card_screen.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';
import '../../provider/cocktail_list_get.dart';

class CocktailCard extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  State<CocktailCard> createState() => _CocktailCardState();
}

class _CocktailCardState extends State<CocktailCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.cocktail.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    try {
      await CocktailRepository().toggleFavorite(widget.cocktail.id, isFavorite);
      setState(() {
        isFavorite = !isFavorite; // Обновляем состояние для изменения иконки
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CocktailCardScreen(cocktail: widget.cocktail)));
      },
      child: Stack(
        children: [
          Card(
            color: const Color(0xff1C1C1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xff343434)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: widget.cocktail.imageUrl != null
                      ? Image.network(
                          widget.cocktail.imageUrl!,
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 190,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.cocktail.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Добавляем иконку в верхний правый угол
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleFavorite, // Вызываем метод для переключения статуса
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
