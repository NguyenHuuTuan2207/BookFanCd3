import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;

  const RoundedButton({
    Key? key, // Key is nullable by using '?'
    required this.text, // Mark as required since it's non-nullable
    required this.press, // Mark as required since it's non-nullable
    this.verticalPadding = 16, // Default value remains
    this.horizontalPadding = 30, // Default value remains
    this.fontSize = 16, // Default value remains
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press(), // Invoke the function safely
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 30,
              color: Color(0xFF666666).withOpacity(.11),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
