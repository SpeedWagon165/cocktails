import 'package:flutter/material.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xff343434)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  cocktail.imageUrl,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Chip(
                  backgroundColor: const Color(0xffFFBA08),
                  label: Text(
                    '${cocktail.points} баллов',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(
                    cocktail.hasAllIngredients
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Добавьте логику для обработки нажатия
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              cocktail.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: cocktail.hasAllIngredients
                ? Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Есть все ингредиенты',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.error, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Не хватает ${cocktail.missingIngredients.join(' и ')}',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class Cocktail {
  final String name;
  final String imageUrl;
  final int points;
  final bool hasAllIngredients;
  final List<String> missingIngredients;

  Cocktail({
    required this.name,
    required this.imageUrl,
    required this.points,
    required this.hasAllIngredients,
    required this.missingIngredients,
  });
}
