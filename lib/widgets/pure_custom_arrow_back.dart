import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PureCustomArrowBack extends StatelessWidget {
  const PureCustomArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/arrow_back.svg',
          width: 13,
          height: 13,
        ),
        iconSize: 30.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 24.0,
        tooltip: 'Back',
      ),
    );
  }
}
