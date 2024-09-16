import "package:cocktails/theme/theme_extensions.dart";
import "package:cocktails/widgets/bonus_story_list/bonus_story_widget.dart";
import "package:cocktails/widgets/custom_button.dart";
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
              CustomArrowBack(
                auth: true,
                text: "Мои баллы",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 46.0),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String points = '0 баллов';

                  if (state is ProfileLoaded) {
                    final profile = state.profileData;
                    final pointsCount = profile['points']; // Количество баллов

                    points = '$pointsCount баллов';
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
                  text: "Обменять баллы",
                  single: true,
                  onPressed: () {},
                  gradient: true),
              const SizedBox(height: 45.0),
              const BonusStoryWidget(),
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
