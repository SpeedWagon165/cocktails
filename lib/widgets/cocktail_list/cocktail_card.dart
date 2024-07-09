import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';

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
                child: cocktail.imageUrl != null
                    ? Image.network(
                        cocktail.imageUrl!,
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
              Positioned(
                top: 10,
                left: 10,
                child: Chip(
                  backgroundColor: const Color(0xffFFBA08),
                  label: Text(
                    '${cocktail.ingredientCount} балла',
                    style: const TextStyle(color: Colors.black),
                  ),
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
            padding: const EdgeInsets.all(12.0),
            child: Text(
              cocktail.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
