import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum JoinPosition { none, top, bottom }

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final bool isJoined;
  final JoinPosition joinPosition;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.isJoined = false,
    this.joinPosition = JoinPosition.none,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isJoined) {
      if (joinPosition == JoinPosition.top) {
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        );
      } else if (joinPosition == JoinPosition.bottom) {
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
        padding: const EdgeInsets.only(left: 18.0, top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: const TextStyle(color: Colors.grey),
            ),
            TextField(
              obscureText: obscureText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
