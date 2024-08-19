import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/cocktail_list_model.dart';

class ToolsListCard extends StatelessWidget {
  final Tool tool;
  final bool border;

  const ToolsListCard({
    super.key,
    required this.tool,
    this.border = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(
              tool.name,
              style:
                  context.text.buttonText18Brown.copyWith(color: Colors.white),
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
                onPressed: () {
                  // Здесь можно добавить логику перехода к подробной информации о инструменте
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 24.0,
                tooltip: 'Подробнее',
              ),
            ),
          ),
        ),
        if (border) const Divider(color: Color(0xff343434), height: 1),
      ],
    );
  }
}
