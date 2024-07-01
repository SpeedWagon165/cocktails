import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

enum JoinPosition { none, top, bottom }

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final bool isJoined;
  final bool phoneNumber;
  final JoinPosition joinPosition;
  final TextEditingController? controller;
  final bool isReferral;
  final bool isDate;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.isJoined = false,
    this.phoneNumber = false,
    this.joinPosition = JoinPosition.none,
    this.controller,
    this.isReferral = false,
    this.isDate = false,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _showReferralInfo = false;

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

  void _toggleReferralInfo() {
    setState(() {
      _showReferralInfo = !_showReferralInfo;
    });
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.controller?.text = DateFormat('dd.MM.yyyy').format(picked);
    }
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

    return Column(
      children: [
        Container(
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
                  style: context.text.bodyText12Grey,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            widget.isDate ? () => _selectDate(context) : null,
                        child: AbsorbPointer(
                          absorbing: widget.isDate,
                          child: TextField(
                            controller: widget.controller,
                            obscureText: _obscureText,
                            keyboardType: widget.phoneNumber
                                ? TextInputType.phone
                                : TextInputType.text,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 2.0),
                            ),
                            style: context.text.bodyText16White,
                            inputFormatters: widget.phoneNumber
                                ? [MaskedInputFormatter('+#(###) ###-##-##')]
                                : [],
                          ),
                        ),
                      ),
                    ),
                    if (widget.obscureText)
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            _obscureText
                                ? 'assets/images/hide_password.svg'
                                : 'assets/images/show_password.svg',
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    if (widget.isReferral)
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: IconButton(
                          icon: SvgPicture.asset('assets/images/referal.svg'),
                          onPressed: _toggleReferralInfo,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_showReferralInfo)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    const Text(
                      'Номер реферала',
                      style: TextStyle(fontSize: 15, color: Color(0xffF6B402)),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      'В данном поле нужно указать номер телефона человека, который порекомендовал вам скачать приложение',
                      style: context.text.bodyText14White.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
