import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'от ${price.toStringAsFixed(0)}₽',
                  style: const TextStyle(
                    color: Color(0xffB7B7B7),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SizedBox(
                    height: 41.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.06),
                        side: BorderSide(
                            color: const Color(0xffF6B402).withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        // Логика заказа
                      },
                      child: const Text(
                        'Заказать',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
