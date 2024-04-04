import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_text_style.dart';

class AppTheme {
  AppTheme._();
  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:  AppColors.whiteColor,
      elevation: 4,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.darkTextColor,
      indicatorColor: AppColors.primaryColor,
      unselectedLabelStyle: AppTextStyle.boldText18.copyWith(
        color: AppColors.darkTextColor,
      ),
      labelStyle: AppTextStyle.boldText18.copyWith(
        color:AppColors.primaryColor,
      )
    ),
    cardTheme: const CardTheme(
      color: AppColors.whiteColor,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor:  MaterialStateProperty.resolveWith((states) {
        return Colors.white;
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryColor;
        }
        return Colors.transparent;
      }),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      iconSize: 28,

    ),
    textTheme: const TextTheme(),
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTextStyle.boldText20.copyWith(
        color: AppColors.blackColor,
      ),
      elevation: 0,
      centerTitle: true,
      color: AppColors.whiteColor,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.iconColor,
      size: 24,
    )
  );
}
