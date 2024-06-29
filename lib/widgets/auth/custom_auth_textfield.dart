import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum JoinPosition { none, top, bottom }

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final bool isJoined;
  final bool phoneNumber;
  final JoinPosition joinPosition;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.isJoined = false,
    this.phoneNumber = false,
    this.joinPosition = JoinPosition.none,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isJoined) {
      if (widget.joinPosition == JoinPosition.top) {
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        );
      } else if (widget.joinPosition == JoinPosition.bottom) {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        );
      } else {
        borderRadius = BorderRadius.zero;
      }
    } else {
      borderRadius = BorderRadius.circular(10.0);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: borderRadius,
        border: Border.all(color: const Color(0xFF343434), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 15.0, right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: context.textStyles.bodyText12Grey,
            ),
            Row(
              children: [
                if (widget.phoneNumber)
                  Expanded(
                    child: TextField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 2.0),
                      ),
                      style: context.textStyles.bodyText16White,
                      inputFormatters: [
                        MaskedInputFormatter('+#(###) ###-##-##')
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: TextField(
                      obscureText: _obscureText,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 2.0),
                      ),
                      style: context.textStyles.bodyText16White,
                    ),
                  ),
                if (widget.obscureText)
                  Transform.translate(
                    offset: const Offset(0, -12),
                    // Сдвиг иконки вверх на 8 пикселей
                    child: IconButton(
                      icon: SvgPicture.asset(
                        _obscureText
                            ? 'assets/images/hide_password.svg'
                            : 'assets/images/show_password.svg',
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
