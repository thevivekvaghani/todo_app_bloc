import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_text_style.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText, labelText;
  final bool readOnly;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? minLines;
  final int maxLines;
  final bool filled;
  final Color? fillColor;
  final double borderRadius;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextAlign textAlign;
  final Color? cursorColor;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Color? borderRadiusColor;
  final BoxConstraints? suffixIconConstraints;
  const AppTextFormField({
    Key? key,
    this.keyboardType,
    this.hintText,
    this.labelText,
    this.autofocus = false,
    this.onSaved,
    this.onTap,
    this.onChanged,
    this.validator,
    this.controller,
    this.focusNode,
    this.minLines,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.borderRadius = 8,
    this.textCapitalization = TextCapitalization.none,
    this.filled = true,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.fillColor,
    this.focusedErrorBorder,
    this.errorBorder,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.borderRadiusColor,
    this.suffixIconConstraints,
    this.cursorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return TextFormField(
      style: textStyle ??
          AppTextStyle.formFieldText,
      textAlign: textAlign,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      focusNode: focusNode,
      cursorColor: cursorColor,
      controller: controller,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      obscureText: obscureText,
      onSaved: onSaved,
      onTap: onTap,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        contentPadding: contentPadding,
        filled: filled,
        fillColor: fillColor ?? Theme.of(context).scaffoldBackgroundColor,
        hintStyle: hintStyle ??
            AppTextStyle.formFieldText.copyWith(
              color: AppColors.hintTextColor,
            ),
        prefixIcon: prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: suffixIcon,
        ),
        errorMaxLines: 3,
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: AppColors.borderColor,),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: AppColors.borderColor,),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: AppColors.borderColor,),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: AppColors.borderColor,),
        ),
      ),
    );
  }
}
