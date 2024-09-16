import 'package:carousel_slider/carousel_slider.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;

  const CocktailCardSlider({super.key, required this.imageUrls});

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.imageUrls.isNotEmpty ? widget.imageUrls.length : 1,
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        height: 340.0,
        aspectRatio: 1,
        viewportFraction: 1,
        initialPage: 0,
      ),
      itemBuilder: (context, index, pageIndex) {
        // Если изображений нет, показываем заглушку
        if (widget.imageUrls.isEmpty) {
          return Container(
            width: double.infinity,
            height: 340,
            color: Colors.grey, // Серый фон
            child: const Icon(
              Icons.image, // Иконка изображения
              color: Colors.white,
              size: 100,
            ),
          );
        } else {
          return Stack(
            children: [
              Image.network(
                widget.imageUrls[index],
                fit: BoxFit.fitHeight,
                width: double.infinity,
                height: 340,
              ),
              Positioned(
                right: 16.0,
                bottom: 10.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    "${index + 1}/${widget.imageUrls.length}",
                    style: context.text.bodyText11Grey.copyWith(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
