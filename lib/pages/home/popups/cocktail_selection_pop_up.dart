import 'package:flutter/material.dart';

import '../cocktail_selection_page.dart';

void cocktailSelectionPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SingleChildScrollView(child: CocktailSelectionPage());
    },
  );
}