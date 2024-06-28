import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';

class CenterText extends StatelessWidget {
  final String text;
  final double padding;

  const CenterText({
    required this.text,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Center(
        child: Text(
          text,
          style: context.textStyles.bodyText12Grey.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
