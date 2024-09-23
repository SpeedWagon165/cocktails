import "package:cocktails/theme/theme_extensions.dart";
import "package:cocktails/widgets/custom_button.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../bloc/profile_bloc/profile_bloc.dart";
import "../../widgets/custom_arrowback.dart";

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 40),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CustomAppBar(
                auth: true,
                text: tr('bonus_screen.title'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 46.0),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String points = tr('bonus_screen.no_points');

                  if (state is ProfileLoaded) {
                    final profile = state.profileData;
                    final pointsCount =
                        profile['points'] ?? 0; // Количество баллов

                    points = tr('bonus_screen.points',
                        namedArgs: {'points': pointsCount.toString()});
                  }

                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      points,
                      textAlign: TextAlign.center,
                      style:
                          context.text.headline24White.copyWith(fontSize: 40.0),
                    ),
                  );
                },
              ),
              const SizedBox(height: 45.0),
              CustomButton(
                text: tr('bonus_screen.redeem_points_button'),
                single: true,
                onPressed: () {
                  // Логика обмена баллов
                },
                gradient: true,
              ),
              const SizedBox(height: 45.0),
              // const BonusStoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
//Вручную обновить баллы void onPointsUpdated() {
//   context.read<ProfileBloc>().add(UpdatePoints());
// }
