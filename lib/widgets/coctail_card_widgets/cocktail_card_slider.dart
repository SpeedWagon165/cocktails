import 'package:carousel_slider/carousel_slider.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CocktailCardSlider extends StatefulWidget {
  const CocktailCardSlider({super.key});

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: items.length,
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        height: 340.0,
        aspectRatio: 1,
        viewportFraction: 1,
        initialPage: 0,
      ),
      itemBuilder: (context, index, pageIndex) => Stack(
        children: [
          Image.asset(
            items[index],
            fit: BoxFit.fitHeight,
          ),
          Positioned(
            right: 16.0,
            bottom: 10.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.white),
              child: Text(
                "${index + 1}/${items.length}",
                style: context.text.bodyText11Grey.copyWith(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> items = [
    "assets/images/coCKtail_card_image_test.png",
    "assets/images/coCKtail_card_image_test.png",
    "assets/images/coCKtail_card_image_test.png",
    "assets/images/coCKtail_card_image_test.png",
    "assets/images/coCKtail_card_image_test.png"
  ];
}
