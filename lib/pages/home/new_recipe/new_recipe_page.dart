import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/auth/custom_auth_textfield.dart';
import 'package:cocktails/widgets/home/create_cocktail_widgets/solid_add_photo_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/home/create_cocktail_widgets/change_cocktail_tile.dart';
import '../../../widgets/home/create_cocktail_widgets/new_recipe_pop_up.dart';

class NewRecipePage extends StatelessWidget {
  const NewRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<CocktailCreationBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  text: tr('new_recipe.title'), // локализованная строка
                  arrow: true,
                  onPressed: null,
                ),
                const SizedBox(
                  height: 27,
                ),
                Text(
                  tr('new_recipe.photo'), // локализованная строка
                  style: context.text.bodyText14White.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                SolidAddPhotoButton(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NewRecipePage()));
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  tr('new_recipe.video'), // локализованная строка
                  style: context.text.bodyText14White.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  labelText:
                      tr('new_recipe.youtube_link'), // локализованная строка
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  labelText: tr('new_recipe.description'),
                  // локализованная строка
                  expandText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF343434), width: 1.0),
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ChangeCocktailTile(
                        name: tr('new_recipe.alcoholic_drinks'),
                        // локализованная строка
                        onTap: () {
                          openAlcoholicModal(context);
                        },
                      ),
                      ChangeCocktailTile(
                        name: tr('new_recipe.non_alcoholic_drinks'),
                        selectedCount: 1,
                        // cocktailBloc.state.getSelectedCountForSection(1),
                        onTap: () {
                          openNonAlcoholicModal(context);
                        },
                      ),
                      ChangeCocktailTile(
                        name: tr('new_recipe.ingredients'),
                        onTap: () {
                          openProductModal(context);
                        },
                      ),
                      ChangeCocktailTile(name: tr('new_recipe.tools')),
                      ChangeCocktailTile(
                        name: tr('new_recipe.steps'), // локализованная строка
                        border: false,
                      ),
                    ])),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: CustomButton(
                          text: tr('buttons.cancel'), // локализованная строка
                          grey: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          single: false,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: CustomButton(
                          text: tr('buttons.save'), // локализованная строка
                          onPressed: () {},
                          single: false,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0B0B0B),
    );
  }
}
