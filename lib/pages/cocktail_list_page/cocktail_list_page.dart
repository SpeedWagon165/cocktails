import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_arrowback.dart';

class CocktailListPage extends StatefulWidget {
  const CocktailListPage({super.key});

  @override
  State<CocktailListPage> createState() => CocktailListPageState();
}

class CocktailListPageState extends State<CocktailListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomArrowBack(
          auth: true,
          text: "18 рецептов",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
