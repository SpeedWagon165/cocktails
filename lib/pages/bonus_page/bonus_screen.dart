import "package:cocktails/theme/theme_extensions.dart";
import "package:cocktails/widgets/bonus_story_list/bonus_story_widget.dart";
import "package:cocktails/widgets/custom_button.dart";
import "package:flutter/material.dart";

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
              Container(
                alignment: Alignment.center,
                child: Text(
                  "154 балла",
                  textAlign: TextAlign.center,
                  style: context.text.headline24White.copyWith(fontSize: 40.0),
                ),
              ),
              const SizedBox(height: 45.0),
              CustomButton(
                  text: "Обменять баллы",
                  single: true,
                  onPressed: () {},
                  gradient: true),
              const SizedBox(height: 45.0),
              BonusStoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
