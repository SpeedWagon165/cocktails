import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final String? errorMessage;
  final bool expandText; // Новое поле для расширения текста
  final bool showRedBorder;

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
    this.errorMessage,
    this.expandText = false,
    this.showRedBorder = false, // По умолчанию поле не расширяется
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _showReferralInfo = false;
  final FocusNode _focusNode = FocusNode();

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x05FFFFFF),
            borderRadius: borderRadius,
            border: Border.all(
              color: (widget.errorMessage != null || widget.showRedBorder)
                  ? Colors
                      .red // Красная граница в случае ошибки или общей ошибки
                  : const Color(0xFF343434),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0), // Уменьшенный padding
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    obscureText: _obscureText,
                    maxLines: widget.expandText ? null : 1,
                    // Управляем расширением текста
                    minLines: 1,
                    // Минимальная линия - одна
                    keyboardType: widget.phoneNumber
                        ? TextInputType.phone
                        : TextInputType.multiline,
                    // Включаем multiline
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onTap: widget.isDate ? () => _selectDate(context) : null,
                  ),
                ),
                if (widget.obscureText)
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        _obscureText
                            ? 'assets/images/hide_password.svg'
                            : 'assets/images/show_password.svg',
                        width: 14,
                        height: 14,
                      ),
                      onPressed: _togglePasswordVisibility,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                if (widget.isReferral)
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/referal.svg',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: _toggleReferralInfo,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorMessage != null && widget.showRedBorder == false)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 16.0),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
              ),
            ),
          )
        else if (widget.showRedBorder == true)
          const SizedBox(),
        if (_showReferralInfo)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Номер реферала',
                      style: TextStyle(fontSize: 15, color: Color(0xffF6B402)),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'В данном поле нужно указать номер телефона человека, который порекомендовал вам скачать приложение',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), height: 1.5),
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
