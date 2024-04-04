import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final Color textColor, buttonColor;
  final double textFontSize, elevation;
  final FontWeight textFontWeight;
  final void Function()? onPressed;
  final bool loading;
  final EdgeInsets padding;
  final double radius;
  final BorderSide? borderSide;

  const AppElevatedButton({
    super.key,
    required this.text,
    this.textColor = AppColors.whiteColor,
    this.textFontSize = 16.0,
    this.elevation = 0,
    this.textFontWeight = FontWeight.w600,
    this.buttonColor = AppColors.buttonColor,
    this.onPressed,
    this.loading = false,
    this.padding = const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 16.0,
    ),
    this.radius = 15.0,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Card(
              elevation: elevation,
              color: buttonColor,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
                child: Container(
                  height: 30.0,
                  width: 30.0,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: borderSide ?? BorderSide.none,
          ),
          padding: padding,
          maximumSize: const Size(double.infinity, 54),
          minimumSize: const Size(double.infinity, 54),
        ),
        onPressed: loading ? () {} : onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textFontSize,
            color: textColor,
            fontWeight: textFontWeight,
          ),
        ),
      ),
    );
  }
}
