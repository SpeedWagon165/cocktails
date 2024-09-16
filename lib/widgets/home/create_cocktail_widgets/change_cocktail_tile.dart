import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeCocktailTile extends StatelessWidget {
  final String name;
  final bool border;
  final Function()? onTap;

  const ChangeCocktailTile({
    super.key,
    this.border = true,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap!();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: ListTile(
              title: Text(
                name,
                style: context.text.buttonText18Brown
                    .copyWith(color: Colors.white),
              ),
              trailing: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/arrow_forward.svg',
                    width: 10,
                    height: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  iconSize: 30.0,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 24.0,
                  tooltip: 'Подробнее',
                ),
              ),
            ),
          ),
        ),
        if (border) const Divider(color: Color(0xff343434), height: 1),
      ],
    );
  }
}
