import 'package:cocktails/theme/theme_extensions.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String titleText;
  final String text;

  const ExpandableTextWidget(
      {super.key, required this.text, required this.titleText});

  @override
  ExpandableTextWidgetState createState() => ExpandableTextWidgetState();
}

class ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            widget.titleText,
            style: context.text.bodyText16White
                .copyWith(fontSize: 18), // Ваш стиль текста
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined,
            color: Colors.white,
          ),
        ),
      ),
      ExpandableText(
        textAlign: TextAlign.start,
        widget.text,
        expandText: '',
        collapseText: '',
        maxLines: isExpanded ? 20 : 4,
        // Логика управления строками
        linkColor: const Color(0xFFB7B7B7),
        style: context.text.bodyText12Grey.copyWith(fontSize: 16, height: 1.5),
        animation: true,
        collapseOnTextTap: true,
      ),
    ]);
  }
}
