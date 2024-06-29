import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCircularCheckbox extends StatefulWidget {
  const CustomCircularCheckbox({super.key});

  @override
  CustomCircularCheckboxState createState() => CustomCircularCheckboxState();
}

class CustomCircularCheckboxState extends State<CustomCircularCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isChecked ? const Color(0xFFF6B402) : Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: _isChecked
            ? Center(
                child: SvgPicture.asset(
                  'assets/images/check.svg',
                  width: 7,
                  height: 7,
                ),
              )
            : null,
      ),
    );
  }
}
