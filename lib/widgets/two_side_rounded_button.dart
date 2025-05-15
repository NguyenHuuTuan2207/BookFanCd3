import 'package:bookfan/consttants.dart';
import 'package:flutter/material.dart';

class TwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radious;
  final Function press;

  const TwoSideRoundedButton({
    Key? key, // Key is now nullable
    required this.text, // Mark text as required
    this.radious = 29, // Default value remains for radious
    required this.press, // Mark press as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press(), // Safely invoke the press function
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: kBlackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radious),
            bottomRight: Radius.circular(radious),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
