import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class IngredientsListCard extends StatelessWidget {
  const IngredientsListCard(
      {super.key,
      required this.title,
      required this.count,
      required this.type,
      required this.border});

  final String title;
  final String type;
  final String count;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.text.headline20White
                    .copyWith(color: Colors.white, fontSize: 15.0),
              ),
              Text("$count $type",
                  style: context.text.headline20White.copyWith(
                      color: const Color(0xFFB7B7B7), fontSize: 15.0)),
            ],
          ),
        ),
        border
            ? const Divider(
                color: Color(0xFF343434),
                height: 1.0,
              )
            : const SizedBox()
      ],
    );
  }
}
